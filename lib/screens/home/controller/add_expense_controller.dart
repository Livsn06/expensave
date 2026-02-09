import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddExpenseController extends GetxController {
  final homeController = Get.find<HomeController>();
  final subtractedAmount = 0.0.obs;
  final formKey = Rx(GlobalKey<FormState>());

  //
  final amountController = Rx(TextEditingController());
  final notesController = Rx(TextEditingController());
  final dateController = Rx(TextEditingController());
  final categoryController = Rx(TextEditingController(text: ""));

  //

  String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    return null;
  }

  String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  String? categoryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please choose a category';
    }
    return null;
  }

  Future<void> addExpense() async {
    if (formKey.value.currentState!.validate()) {
      final amount = double.tryParse(amountController.value.text);
      final note = notesController.value.text;
      final category = categoryController.value.text;

      if (amount == null) {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
        return;
      }

      if (amount > homeController.wallet.value.walletBalance) {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
        return;
      }

      homeController.wallet.value = homeController.wallet.value.copyWith(
        walletBalance: homeController.wallet.value.walletBalance - amount,
        walletOpen: true,
      );

      await DBService.instance.updateWallet(
        homeController.wallet.value.walletId!,
        homeController.wallet.value,
      );

      final transaction = TransactionModel(
        amount: amount,
        note: note,
        type: category,
        icon: getExpenseCategoryIcon(category),
        walletId: homeController.wallet.value.walletId!,
        date: dateController.value.text,
      );

      homeController.transactions.insert(0, transaction);
      await DBService.instance.addTransaction(transaction);

      subtractedAmount.value = subtractedAmount.value + amount;

      amountController.value.clear();
      notesController.value.clear();
      dateController.value.clear();
      categoryController.value = TextEditingController(text: "");
      homeController.getTotalMonthlyExpense();

      homeController.monthlyExpense.refresh();
      homeController.wallet.refresh();
      homeController.transactions.refresh();
    }
  }

  void selectDate() async {
    final selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );

    if (selectedDate != null) {
      dateController.value.text = DateFormat(
        'MMM dd, yyyy',
      ).format(selectedDate);
    }
  }

  String getExpenseCategoryIcon(String categoryName) {
    if (categoryName == 'Groceries') {
      return ImagePath.grocery;
    } else if (categoryName == 'Utilities') {
      return ImagePath.utilities;
    } else if (categoryName == 'Entertainment') {
      return ImagePath.entertainment;
    } else if (categoryName == 'Clothing') {
      return ImagePath.clothing;
    } else if (categoryName == 'Health') {
      return ImagePath.health;
    } else if (categoryName == 'Transportation') {
      return ImagePath.transport;
    } else if (categoryName == 'Food') {
      return ImagePath.food;
    } else {
      return ImagePath.addedExpense;
    }
  }
}
