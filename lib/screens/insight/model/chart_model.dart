import 'package:flutter/material.dart';

class CategoryData {
  final String category;
  final double totalAmount;
  final Color color;

  CategoryData({
    required this.category,
    required this.totalAmount,
    required this.color,
  });

  int getPercentage(double overAllExpense) {
    double percent = (totalAmount / overAllExpense) * 100;
    return int.parse(percent.toStringAsFixed(0));
  }
}
