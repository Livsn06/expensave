import 'dart:typed_data';

import 'package:expensave/helper/db/service/db-service.dart';

import 'package:expensave/screens/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditWalletController extends GetxController {
  final settingController = Get.find<SettingController>();
  RxBool isLoaded = true.obs;
  //

  final formKey = Rx<GlobalKey<FormState>>(GlobalKey<FormState>());
  final walletNameController = Rx<TextEditingController>(
    TextEditingController(),
  );
  final walletNoteController = Rx<TextEditingController>(
    TextEditingController(),
  );

  final imageSelected = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() {
    walletNameController.value.text = settingController.wallet.value.walletName;
    walletNoteController.value.text =
        settingController.wallet.value.walletNote ?? '';
    imageSelected.value = settingController.wallet.value.walletIcon;

    walletNameController.refresh();
    walletNoteController.refresh();
    imageSelected.refresh();
  }

  Future<void> editWallet() async {
    isLoaded.value = false;

    await Future.delayed(const Duration(seconds: 3));
    if (!formKey.value.currentState!.validate()) {
      isLoaded.value = true;
      return;
    }

    final wallet = settingController.wallet.value.copyWith(
      walletName: walletNameController.value.text,
      walletNote: walletNoteController.value.text,
      walletIcon: imageSelected.value,
      walletOpen: true,
    );

    await DBService.instance.updateWallet(wallet.walletId!, wallet);

    isLoaded.value = true;

    settingController.wallet.value = wallet;
    settingController.wallet.refresh();

    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(const SnackBar(content: Text('Wallet update saved.')));
    Get.back();
  }

  String? walletNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a wallet name';
    }
    return null;
  }

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    final bytes = await image!.readAsBytes();
    imageSelected.value = bytes;
    imageSelected.refresh();
  }
}
