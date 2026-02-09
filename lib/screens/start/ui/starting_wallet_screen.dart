import 'package:expensave/const/app/color.dart';
import 'package:expensave/screens/start/controller/starting_wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class StartingWalletScreen extends StatelessWidget {
  StartingWalletScreen({super.key, this.title = 'Create your first wallet'});
  String title;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StartingWalletController(),
      builder: (controller) {
        return Form(
          key: controller.formKey.value,
          child: Scaffold(
            backgroundColor: AppColor.bgWhite,
            extendBody: true,
            appBar: AppBar(backgroundColor: AppColor.bgWhite, elevation: 0),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Text(
                      'Organize your money by creating separate Wallets for different needs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.labelColor,
                      ),
                    ),

                    SizedBox(height: 50),

                    Column(
                      children: [
                        Obx(() {
                          return TextFormField(
                            readOnly: !controller.isLoaded.value,
                            controller: controller.walletNameController.value,
                            validator: controller.walletNameValidator,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              labelText: 'Wallet Name',
                              labelStyle: TextStyle(color: AppColor.labelColor),
                            ),
                          );
                        }),

                        SizedBox(height: 14),
                        Obx(() {
                          return TextFormField(
                            readOnly: !controller.isLoaded.value,
                            controller: controller.walletAmountController.value,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              labelText: 'Starting Amount (Optional)',
                              labelStyle: TextStyle(color: AppColor.labelColor),
                              prefixText: '₱ ',
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            persistentFooterDecoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            persistentFooterButtons: [
              Center(
                child: Obx(() {
                  return MaterialButton(
                    onPressed: () async {
                      if (!controller.isLoaded.value) return;
                      await controller.createWallet(
                        title == 'Create your first wallet' ? 1 : null,
                      );
                    },
                    minWidth: 300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColor.primaryColor,
                    child: !controller.isLoaded.value
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: AppColor.bgWhite,
                            size: 20,
                          )
                        : Text(
                            'Create',
                            style: TextStyle(color: AppColor.bgWhite),
                          ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
