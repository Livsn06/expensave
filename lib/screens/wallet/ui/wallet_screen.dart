import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/screens/setting/controller/setting_controller.dart';
import 'package:expensave/screens/wallet/controller/wallet_controller.dart';
import 'package:expensave/screens/wallet/ui/edit_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.bgWhite,
          appBar: AppBar(backgroundColor: AppColor.bgWhite, elevation: 0),
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Obx(() {
                      if (settingController.wallet.value.walletIcon != null) {
                        return CircleAvatar(
                          backgroundColor: AppColor.primaryColor,
                          radius: 60,
                          child: CircleAvatar(
                            backgroundColor: AppColor.bgWhite,
                            radius: 55,
                            backgroundImage: MemoryImage(
                              settingController.wallet.value.walletIcon!,
                            ),
                          ),
                        );
                      }

                      return CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        radius: 60,
                        child: CircleAvatar(
                          backgroundColor: AppColor.bgWhite,
                          radius: 55,
                          backgroundImage: AssetImage(ImagePath.noImage),
                          child: CircleAvatar(
                            backgroundColor: const Color(0x4F183067),
                            radius: 55,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      return Text(
                        settingController.wallet.value.walletName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: AppColor.primaryColor,
                        ),
                      );
                    }),

                    Obx(() {
                      if (settingController.wallet.value.walletNote != null) {
                        return Text(
                          settingController.wallet.value.walletNote!,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        );
                      }
                      return SizedBox(height: 0);
                    }),
                    SizedBox(height: 8),
                    Obx(() {
                      return Tooltip(
                        padding: EdgeInsets.all(16),
                        triggerMode: TooltipTriggerMode.tap,
                        message:
                            "ID: ${settingController.wallet.value.walletId}"
                            "\nCurrent Balance: ₱${settingController.wallet.value.walletBalance.toStringAsFixed(2)}"
                            "\nTotal transactions: ${settingController.totalTransaction.value}",

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.grey,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "More info",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade400, thickness: 0.6),
                    SizedBox(height: 12),

                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(
                            () => const EditWalletScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                        tileColor: AppColor.bgWhite,
                        leading: Icon(
                          Icons.edit_outlined,
                          color: AppColor.primaryColor,
                          size: 24,
                        ),
                        title: Text(
                          "Edit Information",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          "Change wallet information.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade400, thickness: 0.6),
                    SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        onTap: () {
                          controller.confirmReset();
                        },
                        tileColor: AppColor.bgWhite,
                        leading: Icon(
                          Icons.cleaning_services_outlined,
                          color: Colors.orange,
                          size: 24,
                        ),
                        title: Text(
                          "Reset Data",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.orange,
                          ),
                        ),
                        subtitle: Text(
                          "Balance and transactions will be deleted.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        onTap: () {
                          controller.confirmDelete();
                        },
                        tileColor: AppColor.bgWhite,
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        ),
                        title: Text(
                          "Delete Wallet",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        subtitle: Text(
                          "Delete current wallet. This action cannot be undone.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                    Spacer(),

                    Text(
                      'Started this wallet on December 12, 2025 ✨',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
