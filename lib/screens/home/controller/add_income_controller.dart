import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddIncomeController extends GetxController {
  final homeController = Get.find<HomeController>();
  final addedAmount = 0.0.obs;
  final formKey = Rx(GlobalKey<FormState>());

  //
  final amountController = Rx(TextEditingController());
  final notesController = Rx(TextEditingController());
  final dateController = Rx(TextEditingController());

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

  Future<void> addIncome() async {
    if (formKey.value.currentState!.validate()) {
      final amount = double.tryParse(amountController.value.text);
      final note = notesController.value.text;

      if (amount == null) {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
        return;
      }

      if (amount <= 0.0) {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
        return;
      }

      homeController.wallet.value = homeController.wallet.value.copyWith(
        walletBalance: homeController.wallet.value.walletBalance + amount,
        walletOpen: true,
      );

      await DBService.instance.updateWallet(
        homeController.wallet.value.walletId!,
        homeController.wallet.value,
      );

      final transaction = TransactionModel(
        amount: amount,
        note: note,
        type: 'Income',
        icon: ImagePath.addedMoney,
        walletId: homeController.wallet.value.walletId!,
        date: dateController.value.text,
      );

      homeController.transactions.insert(0, transaction);
      await DBService.instance.addTransaction(transaction);

      addedAmount.value = addedAmount.value + amount;

      amountController.value.clear();
      notesController.value.clear();
      dateController.value.clear();
      homeController.getTotalMonthlyIncome();

      homeController.monthlyIncome.refresh();
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
}
