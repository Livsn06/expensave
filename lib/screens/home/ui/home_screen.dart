import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/navigation/controller/navigation_controller.dart';
import 'package:expensave/screens/home/controller/home_controller.dart';
import 'package:expensave/screens/home/ui/choose_transaction_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return Obx(() {
          if (controller.loaded.value == false) {
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
            backgroundColor: AppColor.bgWhite,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),

                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(10),

                        // gradient: LinearGradient(
                        //   colors: [AppColor.primaryColor, AppColor.secondaryColor],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.wallet.value.walletName,
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }),
                                    Obx(() {
                                      return controller
                                                  .wallet
                                                  .value
                                                  .walletNote !=
                                              null
                                          ? Text(
                                              controller
                                                  .wallet
                                                  .value
                                                  .walletNote!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            )
                                          : SizedBox();
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Divider(color: Colors.white, thickness: 1),

                          SizedBox(height: 10),

                          Text(
                            "Total Balance",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          Obx(() {
                            return RichText(
                              text: TextSpan(
                                text: "₱ ",
                                style: TextStyle(
                                  fontSize: 30,
                                  overflow: TextOverflow.fade,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: controller.wallet.value.walletBalance
                                        .toStringAsFixed(2),
                                  ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(height: 8),
                          // INCOME AND EXPENSE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_up,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Monthly Income",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Obx(() {
                                        return Text(
                                          "+₱${controller.monthlyIncome.value.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_down,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Monthly Expense",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Obx(() {
                                        return Text(
                                          "-₱${controller.monthlyExpense.value.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
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

                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final navigation = Get.find<NavigationController>();
                            navigation.changeIndex(1);
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(() {
                        if (controller.transactions.isEmpty) {
                          return Center(
                            child: Text(
                              "No transactions found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: controller.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = controller.transactions[index];
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
                                      controller.formatRelativeFromMMM(
                                        transaction.date,
                                      ),

                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColor.primaryColor,
              onPressed: () {
                Get.to(
                  () => const ChooseTransactionScreen(),
                  transition: Transition.rightToLeft,
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        });
      },
    );
  }
}
