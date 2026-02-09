import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/screens/start/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.bgWhite,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      ImagePath.appLogo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 30),
                  Obx(() {
                    if (!controller.isLoaded.value) {
                      return LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColor.primaryColor,
                        size: 30,
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
