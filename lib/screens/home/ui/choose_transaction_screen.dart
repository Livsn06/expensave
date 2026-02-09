import 'package:expensave/const/app/color.dart';
import 'package:expensave/const/asset/image_path.dart';
import 'package:expensave/screens/home/ui/add_expense_screen.dart';
import 'package:expensave/screens/home/ui/add_income_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseTransactionScreen extends StatelessWidget {
  const ChooseTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgWhite,
      appBar: AppBar(backgroundColor: AppColor.bgWhite, elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Choose Transaction",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 1,
              child: ListTile(
                tileColor: Colors.white,
                leading: Image.asset(
                  ImagePath.incomeIcon,
                  width: 40,
                  height: 40,
                ),
                title: const Text(
                  "Income",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Add a balance to your wallet."),
                onTap: () {
                  Get.to(
                    () => const AddIncomeScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ),

            Card(
              elevation: 1,
              child: ListTile(
                tileColor: Colors.white,
                leading: Image.asset(
                  ImagePath.expenseIcon,
                  width: 40,
                  height: 40,
                ),
                title: const Text(
                  "Expense",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Record your recent expenses."),
                onTap: () {
                  Get.to(
                    () => const AddExpenseScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
