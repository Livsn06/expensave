import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/helper/pref/pref-service.dart';
import 'package:expensave/navigation/ui/navigation_screen.dart';
import 'package:expensave/screens/start/ui/start_screen.dart';
import 'package:expensave/screens/wallet/ui/wallet_selection_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxBool isLoaded = true.obs;

  //
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() async {
    await Future.delayed(const Duration(seconds: 3));

    isLoaded.value = false;

    final isNewUser = await PrefService.checkSession();

    if (isNewUser) {
      Get.offAll(() => const StartScreen(), transition: Transition.fade);
      return;
    }
    // await DBService.instance.deleteDB();
    final isHasOpenWallet = await DBService.instance.getOpenWallet();

    isLoaded.value = true;
    if (isHasOpenWallet != null) {
      Get.offAll(() => const NavigationScreen(), transition: Transition.fade);
    } else {
      Get.offAll(
        () => const WalletSelectionScreen(),
        transition: Transition.fade,
      );
    }
  }
}
