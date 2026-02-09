import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/screens/start/ui/starting_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgWhite,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ImagePath.appLogo, width: 100, height: 100),
              SizedBox(height: 20),
              Text(
                "ExpenSave",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
              Text("Track your expenses and save money."),
            ],
          ),
        ),
      ),
      persistentFooterDecoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
      persistentFooterButtons: [
        Center(
          child: MaterialButton(
            onPressed: () async {
              Get.to(
                () => StartingWalletScreen(),
                transition: Transition.rightToLeft,
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minWidth: 300,
            textColor: Colors.white,
            color: AppColor.primaryColor,
            child: Text("Get Started"),
          ),
        ),
      ],
    );
  }
}
