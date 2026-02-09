import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:expensave/screens/wallet/ui/wallet_selection_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool loaded = true.obs;

  //
  final wallet = Rx<WalletModel>(
    WalletModel(walletBalance: 0.0, walletName: ''),
  );
  final transactions = RxList<TransactionModel>([]);

  RxDouble monthlyIncome = 0.0.obs;
  RxDouble monthlyExpense = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    loaded.value = false;

    await getWalletData();
    await getWalletTransactions();

    getTotalMonthlyIncome();
    getTotalMonthlyExpense();
    loaded.value = true;
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

  void getTotalMonthlyIncome() {
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction.type == 'Income' && isThisMonth(transaction.date)) {
        total += transaction.amount;
      }
    }
    monthlyIncome.value = total;
  }

  void getTotalMonthlyExpense() {
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction.type != 'Income' && isThisMonth(transaction.date)) {
        total += transaction.amount;
      }
    }
    monthlyExpense.value = total;
  }

  ///

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

  //
  bool isThisMonth(String dateString) {
    final date = _parseMMMDate(dateString); // same parser you used before

    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  DateTime _parseMMMDate(String dateString) {
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

    final parts = dateString.replaceAll(",", "").split(" ");
    final month = months[parts[0]]!;
    final day = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }
}
