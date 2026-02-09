import 'package:expensave/screens/start/ui/splash_screen.dart';
import 'package:get/get.dart';

class DeveloperController extends GetxController {
  RxBool isLoaded = true.obs;

  //
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() async {
    await Future.delayed(const Duration(seconds: 4));

    Get.off(() => SplashScreen());
  }
}
