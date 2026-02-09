import 'package:expensave/const/app/color.dart';
import 'package:expensave/screens/start/ui/starting_wallet_screen.dart';
import 'package:expensave/screens/wallet/controller/wallet_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletSelectionScreen extends StatelessWidget {
  const WalletSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: WalletSelectionController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.bgWhite,
          appBar: AppBar(backgroundColor: AppColor.bgWhite, elevation: 0),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Obx(() {
                if (controller.walletList.isEmpty &&
                    controller.recentlyOpenWallet.value == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Choose your wallet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Text(
                        'Select the wallet you want to use to track your expenses.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.labelColor,
                        ),
                      ),

                      SizedBox(height: 50),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'No Wallet Found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColor.labelColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Choose your wallet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Text(
                      'Select the wallet you want to use to track your expenses.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.labelColor,
                      ),
                    ),

                    SizedBox(height: 50),

                    Obx(() {
                      if (controller.recentlyOpenWallet.value == null) {
                        return SizedBox.shrink();
                      }
                      return Wrap(
                        children: [
                          Text(
                            'Recently Used',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.labelColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            child: ListTile(
                              onTap: () {
                                controller.confirmOpenWallet(
                                  controller.recentlyOpenWallet.value!,
                                );
                              },
                              tileColor: Colors.white,
                              leading:
                                  controller
                                          .recentlyOpenWallet
                                          .value!
                                          .walletIcon ==
                                      null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        size: 18,
                                        Icons.wallet,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      backgroundImage: MemoryImage(
                                        controller
                                            .recentlyOpenWallet
                                            .value!
                                            .walletIcon!,
                                      ),
                                    ),
                              title: Text(
                                controller.recentlyOpenWallet.value!.walletName,
                                style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  controller
                                          .recentlyOpenWallet
                                          .value!
                                          .walletNote ==
                                      null
                                  ? null
                                  : Text(
                                      controller
                                          .recentlyOpenWallet
                                          .value!
                                          .walletNote!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.labelColor,
                                      ),
                                    ),
                              trailing: Icon(
                                size: 18,
                                Icons.arrow_forward_ios,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Divider(color: Colors.black12, thickness: 1),
                          ),
                        ],
                      );
                    }),

                    Obx(() {
                      if (controller.walletList.isEmpty) {
                        return SizedBox.shrink();
                      }
                      return Wrap(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'All Wallets',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.labelColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            itemCount: controller.walletList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final wallet = controller.walletList[index];
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    controller.confirmOpenWallet(wallet);
                                  },
                                  tileColor: Colors.white,
                                  leading: wallet.walletIcon == null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          child: Icon(
                                            size: 18,
                                            Icons.wallet,
                                            color: Colors.white,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          backgroundImage: MemoryImage(
                                            wallet.walletIcon!,
                                          ),
                                        ),
                                  title: Text(
                                    wallet.walletName,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: wallet.walletNote == null
                                      ? null
                                      : Text(
                                          wallet.walletNote!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.labelColor,
                                          ),
                                        ),
                                  trailing: Icon(
                                    size: 20,
                                    Icons.swap_horiz_rounded,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }),
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
                    () => StartingWalletScreen(title: 'Create New Wallet'),
                    transition: Transition.rightToLeft,
                  );
                },
                minWidth: 300,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColor.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: AppColor.bgWhite,
                child: Text(
                  'Add New Wallet',
                  style: TextStyle(color: AppColor.primaryColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
