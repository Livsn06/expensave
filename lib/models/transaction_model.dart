import 'package:expensave/helper/db/env/db-env.dart';
import 'package:intl/intl.dart';

class TransactionModel {
  int? id;
  double amount;
  String? note;
  String? type;
  String date;
  int walletId;
  String? icon;
  String? createdAt;

  TransactionModel({
    this.id,
    required this.amount,
    required this.date,
    required this.walletId,
    this.icon,
    this.note,
    this.type,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    DBENV.instance.transactionAmount: amount,
    DBENV.instance.transactionNote: note,
    DBENV.instance.transactionType: type,
    DBENV.instance.transactionDate: date,
    DBENV.instance.transactionIcon: icon,
    DBENV.instance.transactionWalletId: walletId,
    DBENV.instance.createdAt: getDateTimeNow(),
  };

  String getDateTimeNow() =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  TransactionModel copyWith({
    int? id,
    double? amount,
    String? note,
    String? type,
    int? walletId,
    String? date,
    String? icon,
    String? createdAt,
  }) => TransactionModel(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    walletId: walletId ?? this.walletId,
    note: note ?? this.note,
    type: type ?? this.type,
    icon: icon ?? this.icon,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map[DBENV.instance.transactionId],
        amount: map[DBENV.instance.transactionAmount],
        note: map[DBENV.instance.transactionNote],
        type: map[DBENV.instance.transactionType],
        icon: map[DBENV.instance.transactionIcon],
        date: map[DBENV.instance.transactionDate],
        walletId: map[DBENV.instance.transactionWalletId],
        createdAt: map[DBENV.instance.createdAt],
      );
}
