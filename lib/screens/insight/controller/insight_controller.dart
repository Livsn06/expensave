import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:expensave/screens/insight/model/chart_model.dart';
import 'package:expensave/screens/wallet/ui/wallet_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InsightController extends GetxController {
  final wallet = Rx<WalletModel>(
    WalletModel(walletBalance: 0.0, walletName: ''),
  );
  final transactions = RxList<TransactionModel>([]);

  //
  final RxBool isLoaded = true.obs;
  RxInt pageIndex = 0.obs;
  final pageController = Rx(PageController());

  ///
  ///
  RxList<TransactionModel> totalIncomeTransactions = RxList<TransactionModel>(
    [],
  );
  RxList<TransactionModel> totalExpenseTransactions = RxList<TransactionModel>(
    [],
  );

  RxDouble overAllIncome = 0.0.obs;
  RxDouble overAllExpense = 0.0.obs;
  RxString firstDateTransaction = ''.obs;
  RxString latestDateTransaction = ''.obs;
  RxList<CategoryData> categoryData = RxList<CategoryData>([]);

  @override
  void onInit() async {
    super.onInit();

    isLoaded.value = false;
    await getWalletData();
    await getWalletTransactions();

    getOverallExpenseTransactions();
    getOverallIncomeTransactions();

    calculateOverallExpense();
    calculateOverallIncome();

    getFirstDateTransaction();
    getLatestDateTransaction();
    getCategoryList();

    pageController.value = PageController(initialPage: 0);

    isLoaded.value = true;
  }

  Future getWalletData() async {
    final wallet = await DBService.instance.getOpenWallet();

    if (wallet == null) {
      Get.offAll(
        () => const WalletSelectionScreen(),
        transition: Transition.fade,
      );
      return;
    }

    this.wallet.value = wallet;
  }

  Future getWalletTransactions() async {
    transactions.value = await DBService.instance.getWalletTransactions(
      wallet.value.walletId!,
    );
  }

  void nextPage() {
    pageIndex.value = pageIndex.value + 1;
    pageController.value.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void previousPage() {
    pageIndex.value = pageIndex.value - 1;
    pageController.value.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  ///
  ///
  void getOverallExpenseTransactions() {
    List<TransactionModel> expenses = [];
    expenses = transactions
        .where((transaction) => transaction.type != 'Income')
        .toList();

    totalExpenseTransactions.value = expenses;
  }

  void getOverallIncomeTransactions() {
    List<TransactionModel> incomes = [];
    incomes = transactions
        .where((transaction) => transaction.type == 'Income')
        .toList();

    totalIncomeTransactions.value = incomes;
  }

  void calculateOverallExpense() {
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction.type != 'Income') {
        total += transaction.amount;
      }
    }
    overAllExpense.value = total;
  }

  void calculateOverallIncome() {
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction.type == 'Income') {
        total += transaction.amount;
      }
    }
    overAllIncome.value = total;
  }

  ///
  ///

  void getFirstDateTransaction() {
    if (transactions.isEmpty) return;

    final first = transactions.reduce((a, b) {
      final dateA = getDateOfFormattedString(a.date);
      final dateB = getDateOfFormattedString(b.date);

      return dateA.isBefore(dateB) ? a : b;
    });

    firstDateTransaction.value = first.date;
  }

  void getLatestDateTransaction() {
    if (transactions.isEmpty) return;

    final latest = transactions.reduce((a, b) {
      final dateA = getDateOfFormattedString(a.date);
      final dateB = getDateOfFormattedString(b.date);

      return dateA.isAfter(dateB) ? a : b;
    });

    latestDateTransaction.value = latest.date;
  }

  bool isEqualMonth() {
    return firstDateTransaction.value == latestDateTransaction.value;
  }

  DateTime getDateOfFormattedString(String date) {
    return DateFormat('MMM dd, yyyy').parse(date);
  }

  ///
  ///
  ///
  void getCategoryList() {
    final Set<String> categories = {};

    for (var transaction in transactions) {
      if (transaction.type != 'Income') {
        categories.add(transaction.type!);
      }
    }

    // Map categories to CategoryData
    final List<CategoryData> mapped = categories.map((category) {
      return CategoryData(
        category: category,
        totalAmount: getExpenseCategoryAmount(category),
        color: getCategoryColor(category),
      );
    }).toList();

    mapped.sort((a, b) {
      if (a.category == "Other") return 1;
      if (b.category == "Other") return -1;
      return 0;
    });

    categoryData.value = mapped;
  }

  double getExpenseCategoryAmount(String category) {
    return transactions
        .where((transaction) => transaction.type != 'Income')
        .where((transaction) => transaction.type == category)
        .fold<double>(
          0.0,
          (previousValue, element) => previousValue + element.amount,
        );
  }

  //

  String formatRelativeFromMMM(String dateString) {
    try {
      // Parse "Dec 10, 2025"
      final date = DateTime.parse(_convertToISO(dateString));
      return _relativeDate(date, original: dateString);
    } catch (e) {
      return dateString; // fallback
    }
  }

  /// Converts "Dec 10, 2025" → "2025-12-10"
  String _convertToISO(String input) {
    final months = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12,
    };

    final parts = input.replaceAll(",", "").split(" ");
    final month = months[parts[0]]!;
    final day = parts[1];
    final year = parts[2];

    return "$year-${month.toString().padLeft(2, '0')}-${day.padLeft(2, '0')}";
  }

  String _relativeDate(DateTime date, {required String original}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final check = DateTime(date.year, date.month, date.day);

    final diffDays = today.difference(check).inDays;

    if (diffDays == 0) return "Today";
    if (diffDays == 1) return "Yesterday";
    if (diffDays > 1 && diffDays < 7) return "$diffDays days ago";

    final lastMonth = DateTime(now.year, now.month - 1);
    if (date.year == lastMonth.year && date.month == lastMonth.month)
      return "Last month";

    if (date.year == now.year - 1) return "Last year";

    return original; // Fallback: return "Dec 10, 2025"
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Groceries':
        return Colors.orangeAccent;
      case 'Utilities':
        return Colors.blueAccent;
      case 'Clothing':
        return Colors.pinkAccent;
      case 'Health':
        return Colors.deepPurpleAccent;
      case 'Food':
        return Colors.redAccent;
      case 'Transport':
        return Colors.greenAccent;
      case 'Entertainment':
        return Colors.teal;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
