import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/screens/wallet/controller/edit_wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditWalletScreen extends StatelessWidget {
  const EditWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditWalletController(),
      builder: (controller) {
        return Form(
          key: controller.formKey.value,
          child: Scaffold(
            backgroundColor: AppColor.bgWhite,
            extendBody: true,
            appBar: AppBar(backgroundColor: AppColor.bgWhite, elevation: 0),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Edit Your Wallet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Text(
                        'Please enter your wallet details.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.labelColor,
                        ),
                      ),

                      SizedBox(height: 50),

                      Column(
                        children: [
                          InkWell(
                            onTap: () => controller.pickImage(),
                            child: Obx(() {
                              if (controller.imageSelected.value != null) {
                                return CircleAvatar(
                                  backgroundColor: AppColor.primaryColor,
                                  radius: 60,
                                  child: CircleAvatar(
                                    backgroundColor: AppColor.bgWhite,
                                    radius: 55,
                                    backgroundImage: MemoryImage(
                                      controller.imageSelected.value!,
                                    ),
                                    child: CircleAvatar(
                                      radius: 55,
                                      backgroundColor: const Color(0x53183067),
                                      child: Icon(
                                        Icons.edit,
                                        size: 30,
                                        color: Colors.white,
                                      ),
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
                                  backgroundImage: AssetImage(
                                    ImagePath.noImage,
                                  ),

                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: const Color(0x53183067),
                                    child: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 14),
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
                                labelStyle: TextStyle(
                                  color: AppColor.labelColor,
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 14),
                          Obx(() {
                            return TextFormField(
                              maxLines: 3,
                              readOnly: !controller.isLoaded.value,
                              controller: controller.walletNoteController.value,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                labelText: 'Notes (Optional)',
                                labelStyle: TextStyle(
                                  color: AppColor.labelColor,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
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
                      await controller.editWallet();
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
                            'Save',
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
