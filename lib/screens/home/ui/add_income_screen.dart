import 'package:expensave/const/app/color.dart';
import 'package:expensave/screens/home/controller/add_income_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddIncomeScreen extends StatelessWidget {
  const AddIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddIncomeController(),
      builder: (controller) {
        return Form(
          key: controller.formKey.value,
          child: Scaffold(
            backgroundColor: AppColor.bgWhite,
            appBar: AppBar(backgroundColor: AppColor.bgWhite, elevation: 0),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "New Income",
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Obx(() {
                            return Text(
                              '₱${controller.homeController.wallet.value.walletBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                          Obx(() {
                            return controller.addedAmount.value == 0.0
                                ? SizedBox()
                                : Text(
                                    '+ ₱${controller.addedAmount.value.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TextFormField(
                          controller: controller.amountController.value,
                          validator: controller.amountValidator,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Amount"),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          return TextFormField(
                            controller: controller.dateController.value,
                            validator: controller.dateValidator,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.selectDate();
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              label: Text("Date Received"),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 10),

                        TextFormField(
                          controller: controller.notesController.value,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            label: Text("Notes (Optional)"),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
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
                child: MaterialButton(
                  minWidth: double.infinity,
                  textColor: Colors.white,
                  color: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () async {
                    await controller.addIncome();
                  },
                  child: const Text("Add Income"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
