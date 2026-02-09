import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:expensave/screens/wallet/ui/wallet_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  Rx<WalletModel> wallet = Rx(WalletModel(walletName: '', walletBalance: 0.0));
  RxInt totalTransaction = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getCurrentWallet();
    await getTotalTransaction();
  }

  Future getCurrentWallet() async {
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

  Future getTotalTransaction() async {
    final result = await DBService.instance.getWalletTransactions(
      wallet.value.walletId!,
    );
    totalTransaction.value = result.length;
  }

  void confirmCloseWallet() async {
    await Get.defaultDialog(
      title: 'Close wallet',
      content: const Text('Are you sure you want to close this wallet?'),
      confirm: MaterialButton(
        textColor: Colors.white,
        onPressed: closeWallet,
        color: Colors.red,
        child: const Text('Yes'),
      ),
      cancel: MaterialButton(
        textColor: Colors.white,
        color: Colors.grey,
        onPressed: () => Get.back(),
        child: const Text('Back'),
      ),
    );
  }

  Future closeWallet() async {
    wallet.value = wallet.value.copyWith(walletOpen: false);
    await DBService.instance.updateWallet(wallet.value.walletId!, wallet.value);
    Get.offAll(() => const WalletSelectionScreen());
  }
}
