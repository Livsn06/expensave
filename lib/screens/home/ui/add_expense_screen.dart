import 'package:expensave/const/app/color.dart';
import 'package:expensave/screens/home/controller/add_expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddExpenseController(),
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
                      "New Expense",
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
                            return controller.subtractedAmount.value == 0.0
                                ? SizedBox()
                                : Text(
                                    '- ₱${controller.subtractedAmount.value.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Obx(() {
                          return DropdownButtonFormField(
                            initialValue:
                                controller.categoryController.value.text,
                            validator: controller.categoryValidator,
                            dropdownColor: AppColor.bgWhite,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),

                            items: [
                              DropdownMenuItem(
                                value: "",
                                child: Text("Select Category"),
                              ),
                              DropdownMenuItem(
                                value: "Clothing",
                                child: Text("Clothing"),
                              ),
                              DropdownMenuItem(
                                value: "Utilities",
                                child: Text("Utilities"),
                              ),
                              DropdownMenuItem(
                                value: "Transportation",
                                child: Text("Transportation"),
                              ),
                              DropdownMenuItem(
                                value: "Groceries",
                                child: Text("Groceries"),
                              ),
                              DropdownMenuItem(
                                value: "Entertainment",
                                child: Text("Entertainment"),
                              ),
                              DropdownMenuItem(
                                value: "Health",
                                child: Text("Health"),
                              ),
                              DropdownMenuItem(
                                value: "Food",
                                child: Text("Food"),
                              ),
                              DropdownMenuItem(
                                value: "Other",
                                child: Text("Other"),
                              ),
                            ],
                            onChanged: (change) {
                              if (change == null) return;
                              controller.categoryController.value =
                                  TextEditingController(text: change);
                            },
                          );
                        }),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controller.amountController.value,
                          validator: controller.amountValidator,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Expense Amount"),
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
                              label: Text("Date of Transaction"),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.selectDate();
                                },
                                icon: Icon(
                                  Icons.calendar_month,
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
                    await controller.addExpense();
                  },
                  child: const Text("Add Expense"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
