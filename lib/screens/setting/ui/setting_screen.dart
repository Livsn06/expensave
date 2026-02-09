import 'package:expensave/const/app/color.dart';
import 'package:expensave/screens/setting/controller/setting_controller.dart';
import 'package:expensave/screens/wallet/ui/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SettingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.bgWhite,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColor.bgWhite,
            elevation: 0,
            title: Text("Settings"),
          ),
          body: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  onTap: () {
                    Get.to(
                      () => WalletScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  tileColor: AppColor.bgWhite,
                  leading: Icon(
                    Icons.wallet,
                    color: AppColor.primaryColor,
                    size: 30,
                  ),
                  title: Text(
                    "My Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    "Manage your current wallet.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),

              // Card(
              //   child: ListTile(
              //     onTap: () {},
              //     tileColor: Colors.white,
              //     leading: Icon(
              //       Icons.category_outlined,
              //       color: AppColor.primaryColor,
              //       size: 30,
              //     ),
              //     title: Text(
              //       "Categories",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         fontSize: 18,
              //         color: Colors.black87,
              //       ),
              //     ),
              //     subtitle: Text(
              //       "Manage your expense categories.",
              //       style: TextStyle(
              //         fontSize: 12,
              //         color: Colors.black54,
              //         fontStyle: FontStyle.italic,
              //       ),
              //     ),
              //   ),
              // ),
              Card(
                child: ListTile(
                  onTap: () {
                    controller.confirmCloseWallet();
                  },
                  tileColor: Colors.white,
                  leading: Icon(
                    Icons.logout_outlined,
                    color: AppColor.primaryColor,
                    size: 30,
                  ),
                  title: Text(
                    "Close Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    "Close your current wallet and switch to another wallet.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
