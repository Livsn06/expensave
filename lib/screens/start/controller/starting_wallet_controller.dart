import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/helper/pref/pref-service.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:expensave/navigation/ui/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StartingWalletController extends GetxController {
  RxBool isLoaded = true.obs;
  //

  final formKey = Rx<GlobalKey<FormState>>(GlobalKey<FormState>());
  final walletNameController = Rx<TextEditingController>(
    TextEditingController(),
  );
  final walletAmountController = Rx<TextEditingController>(
    TextEditingController(),
  );

  Future<void> createWallet([int? id]) async {
    isLoaded.value = false;

    await Future.delayed(const Duration(seconds: 3));
    if (!formKey.value.currentState!.validate()) {
      isLoaded.value = true;
      return;
    }

    WalletModel wallet = WalletModel(
      walletId: id,
      walletOpen: true,
      walletName: walletNameController.value.text,
      walletBalance: walletAmountController.value.text.isEmpty
          ? 0.0
          : double.parse(walletAmountController.value.text),
    );

    TransactionModel transaction = TransactionModel(
      amount: wallet.walletBalance,
      note: 'Initial balance',
      type: 'Income',
      icon: ImagePath.addedMoney,
      walletId: 1,
      date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
    );

    if (id != null) {
      await DBService.instance.createFirstWallet(wallet);
    } else {
      final newID = await DBService.instance.createWallet(wallet);
      transaction = transaction.copyWith(walletId: newID);
    }

    if (transaction.amount > 0) {
      await DBService.instance.addTransaction(transaction);
    }

    await checkAndStoreUserSession();
    isLoaded.value = true;

    await Get.offAll(
      () => const NavigationScreen(),
      transition: Transition.fade,
    );
  }

  String? walletNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a wallet name';
    }
    return null;
  }

  Future checkAndStoreUserSession() async {
    final isNewUser = await PrefService.checkSession();
    if (isNewUser) {
      PrefService.setUserSession();
    }
  }

  // String? walletAmountValidator(String? value) {
  //   if (value != null && double.tryParse(value) != null) {
  //     return 'Please enter a valid amount';
  //   }
  //   return null;
  // }
}
