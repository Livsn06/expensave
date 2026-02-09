import 'package:expensave/const/app/color.dart';
import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:expensave/navigation/ui/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletSelectionController extends GetxController {
  RxList<WalletModel> walletList = <WalletModel>[].obs;
  Rx<WalletModel?> recentlyOpenWallet = Rx<WalletModel?>(null);

  @override
  void onInit() async {
    super.onInit();
    await getRecentlyOpenedWallet();
    await getAllWallets();
  }

  Future getAllWallets() async {
    final list = await DBService.instance.getAllWallet();

    walletList.value = list
        .where(
          (element) => element.walletId != recentlyOpenWallet.value?.walletId,
        )
        .toList();
  }

  Future getRecentlyOpenedWallet() async {
    recentlyOpenWallet.value = await DBService.instance
        .getRecentlyOpenedWallet();
  }

  void confirmOpenWallet(WalletModel wallet) async {
    Get.defaultDialog(
      title: 'Open ${wallet.walletName}',
      content: const Text('Are you sure you want to open this wallet?'),
      confirm: MaterialButton(
        textColor: Colors.white,
        onPressed: () => openWallet(wallet),
        color: AppColor.primaryColor,
        child: const Text('Open'),
      ),
      cancel: MaterialButton(
        textColor: Colors.white,
        color: Colors.grey,
        onPressed: () => Get.back(),
        child: const Text('Back'),
      ),
    );
  }

  Future openWallet(WalletModel wallet) async {
    wallet = wallet.copyWith(walletOpen: true);
    await DBService.instance.updateWallet(wallet.walletId!, wallet);
    Get.offAll(() => const NavigationScreen());
  }
}
