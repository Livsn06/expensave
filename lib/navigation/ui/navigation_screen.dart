import 'package:expensave/const/app/color.dart';
import 'package:expensave/navigation/controller/navigation_controller.dart';
import 'package:expensave/screens/home/ui/home_screen.dart';
import 'package:expensave/screens/insight/ui/insight_screen.dart';
import 'package:expensave/screens/setting/ui/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const HomeScreen(),
      const InsightScreen(),
      const SettingScreen(),
    ];

    return GetBuilder(
      init: NavigationController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() => screens[controller.currentIndex.value]),

          bottomNavigationBar: Obx(() {
            return BottomNavigationBar(
              backgroundColor: AppColor.bgWhite,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeIndex,
              selectedItemColor: AppColor.primaryColor,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights),
                  label: 'Insight',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
