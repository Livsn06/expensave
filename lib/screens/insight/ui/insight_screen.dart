import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/screens/insight/components/barchart_component.dart';
import 'package:expensave/screens/insight/controller/insight_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: InsightController(),
      builder: (controller) {
        return Obx(() {
          if (!controller.isLoaded.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Loading...", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColor.primaryColor,
                    size: 40,
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: AppColor.bgWhite,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 14,
                          ),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Obx(() {
                                return Text(
                                  controller.isEqualMonth()
                                      ? controller.firstDateTransaction.value
                                      : "${controller.firstDateTransaction.value} - ${controller.latestDateTransaction.value}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),

                              SizedBox(height: 10),
                              Obx(() {
                                if (controller.overAllExpense.value == 0) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                    ),
                                    alignment: Alignment.center,
                                    color: Colors.white24,
                                    child: Text(
                                      "No Expenses Found",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                                return PieChartSample2(
                                  overAllExpense:
                                      controller.overAllExpense.value,
                                  categoryData: controller.categoryData,
                                );
                              }),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          Text(
                                            "Overall Income",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),

                                          Obx(() {
                                            return Text(
                                              "+₱${controller.overAllIncome.value.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.greenAccent,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          Text(
                                            "Overall Expense",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),

                                          Obx(() {
                                            return Text(
                                              "-₱${controller.overAllExpense.value.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.redAccent,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Divider(height: 20),

                        SizedBox(
                          height: 400,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(() {
                                    return TextButton.icon(
                                      style: ButtonStyle(
                                        minimumSize: WidgetStatePropertyAll(
                                          Size(140, 30),
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          controller.pageIndex.value == 0
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          controller.pageIndex.value == 0
                                              ? AppColor.primaryColor
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.previousPage();
                                      },
                                      label: Text("Income"),
                                      icon: Icon(
                                        Icons.arrow_circle_up_outlined,
                                      ),
                                    );
                                  }),
                                  Obx(() {
                                    return TextButton.icon(
                                      style: ButtonStyle(
                                        minimumSize: WidgetStatePropertyAll(
                                          Size(140, 30),
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          controller.pageIndex.value == 1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          controller.pageIndex.value == 1
                                              ? AppColor.primaryColor
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.nextPage();
                                      },
                                      label: Text("Expense"),
                                      icon: Icon(
                                        Icons.arrow_circle_down_outlined,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              Obx(() {
                                return Expanded(
                                  child: PageView(
                                    controller: controller.pageController.value,
                                    onPageChanged: (value) {
                                      controller.pageIndex.value = value;
                                    },
                                    children: [
                                      IncomePage(
                                        transactions:
                                            controller.totalIncomeTransactions,
                                        controller: controller,
                                      ),
                                      ExpensePage(
                                        transactions:
                                            controller.totalExpenseTransactions,
                                        controller: controller,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

// ignore: must_be_immutable
class IncomePage extends StatelessWidget {
  IncomePage({super.key, required this.transactions, required this.controller});

  List<TransactionModel> transactions = [];
  InsightController controller;
  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          "No Records found",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: transactions.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          elevation: 1,
          color: Colors.white,
          child: ListTile(
            leading: Image.asset(
              transaction.icon ?? ImagePath.appLogo,
              width: 30,
              height: 30,
            ),
            title: Text(
              transaction.type ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              transaction.note ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transaction.type! == "Income"
                      ? "+₱${transaction.amount.toStringAsFixed(2)}"
                      : "-₱${transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: transaction.type! == "Income"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  controller.formatRelativeFromMMM(transaction.date),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ExpensePage extends StatelessWidget {
  ExpensePage({
    super.key,
    required this.transactions,
    required this.controller,
  });

  List<TransactionModel> transactions = [];
  InsightController controller;
  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          "No Records found",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: transactions.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          elevation: 1,
          color: Colors.white,
          child: ListTile(
            leading: Image.asset(
              transaction.icon ?? ImagePath.appLogo,
              width: 30,
              height: 30,
            ),
            title: Text(
              transaction.type ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              transaction.note ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transaction.type! == "Income"
                      ? "+₱${transaction.amount.toStringAsFixed(2)}"
                      : "-₱${transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: transaction.type! == "Income"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  controller.formatRelativeFromMMM(transaction.date),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
