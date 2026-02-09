import 'package:expensave/const/app/color.dart';
import 'package:expensave/helper/db/service/db-service.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:expensave/screens/setting/controller/setting_controller.dart';
import 'package:expensave/screens/wallet/ui/wallet_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WalletController extends GetxController {
  RxBool isLoaded = true.obs;
  final settingController = Get.find<SettingController>();
  final formKey = Rx<GlobalKey<FormState>>(GlobalKey<FormState>());
  Rx<TextEditingController> nameController = TextEditingController().obs;

  final wallets = Rx<WalletModel>(
    WalletModel(walletName: '', walletBalance: 0.0),
  );

  @override
  void onInit() async {
    super.onInit();
    wallets.value = settingController.wallet.value;
  }

  void confirmDelete() {
    formKey.value = GlobalKey<FormState>();
    nameController.value = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                return Form(
                  key: formKey.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Delete Wallet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Warning!. This action cannot be undone. Please type the "Wallet Name" to confirm.',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.red,
                        ),
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        validator: (value) => walletNameValidator(
                          value,
                          wallets.value.walletName,
                        ),
                        controller: nameController.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: 'Wallet Name',
                        ),
                      ),

                      SizedBox(height: 16),
                      Obx(() {
                        if (!isLoaded.value) {
                          return MaterialButton(
                            color: Colors.grey,
                            onPressed: null,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColor.primaryColor,
                              size: 20,
                            ),
                          );
                        }
                        return MaterialButton(
                          onPressed: () async {
                            //
                            isLoaded.value = false;

                            await Future.delayed(const Duration(seconds: 2));
                            if (!formKey.value.currentState!.validate() ||
                                wallets.value.walletId == null ||
                                wallets.value.walletName !=
                                    nameController.value.text) {
                              isLoaded.value = true;
                              return;
                            }
                            await deleteWallet();

                            Get.offAll(() => const WalletSelectionScreen());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Wallet deleted!')),
                            );
                            isLoaded.value = true;
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                          child: const Text('Confirm'),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  //
  //

  void confirmReset() {
    formKey.value = GlobalKey<FormState>();
    nameController.value = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                return Form(
                  key: formKey.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Reset Wallet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Warning!. This action cannot be undone. Please type the "Wallet Name" to confirm.',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                        ),
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        validator: (value) => walletNameValidator(
                          value,
                          wallets.value.walletName,
                        ),
                        controller: nameController.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: 'Wallet Name',
                        ),
                      ),

                      SizedBox(height: 16),
                      Obx(() {
                        if (!isLoaded.value) {
                          return MaterialButton(
                            color: Colors.grey,
                            onPressed: null,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColor.primaryColor,
                              size: 20,
                            ),
                          );
                        }
                        return MaterialButton(
                          onPressed: () async {
                            //
                            isLoaded.value = false;

                            await Future.delayed(const Duration(seconds: 2));
                            if (!formKey.value.currentState!.validate() ||
                                wallets.value.walletId == null ||
                                wallets.value.walletName !=
                                    nameController.value.text) {
                              isLoaded.value = true;
                              return;
                            }
                            await resetWallet();

                            Get.back();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Wallet reset!')),
                            );
                            isLoaded.value = true;
                          },
                          color: Colors.orange,
                          textColor: Colors.white,
                          child: const Text('Confirm'),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  String? walletNameValidator(String? value, String? walletName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a wallet name';
    }

    if (value != walletName) {
      return 'Wallet name does not match';
    }

    return null;
  }

  Future deleteWallet() async {
    int id = wallets.value.walletId!;
    await DBService.instance.deleteWallet(id);
    await DBService.instance.deleteWalletTransactions(id);
  }

  Future resetWallet() async {
    int id = wallets.value.walletId!;

    wallets.value = wallets.value.copyWith(
      walletId: id,
      walletOpen: true,
      walletBalance: 0.0,
    );

    await DBService.instance.updateWallet(id, wallets.value);
    await DBService.instance.deleteWalletTransactions(id);
    settingController.wallet.value = wallets.value;
    settingController.wallet.refresh();
    settingController.totalTransaction.value = 0;
    settingController.totalTransaction.refresh();
  }
}
