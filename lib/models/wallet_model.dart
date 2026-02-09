import 'dart:typed_data';

import 'package:expensave/helper/db/env/db-env.dart';
import 'package:intl/intl.dart';

class WalletModel {
  int? walletId;
  String walletName;
  double walletBalance;
  Uint8List? walletIcon;
  bool walletOpen;
  String? walletNote;
  String? createdAt;
  String? updatedAt;

  WalletModel({
    required this.walletName,
    required this.walletBalance,
    this.walletOpen = false,
    this.walletIcon,
    this.walletNote,
    this.walletId,
    this.createdAt,
    this.updatedAt,
  });

  WalletModel copyWith({
    int? walletId,
    String? walletName,
    double? walletBalance,
    Uint8List? walletIcon,
    bool? walletOpen,
    String? walletNote,
  }) => WalletModel(
    walletId: walletId ?? this.walletId,
    walletName: walletName ?? this.walletName,
    walletBalance: walletBalance ?? this.walletBalance,
    walletIcon: walletIcon ?? this.walletIcon,
    walletOpen: walletOpen ?? this.walletOpen,
    walletNote: walletNote ?? this.walletNote,
    updatedAt: getDateTimeNow(),
    createdAt: createdAt,
  );

  factory WalletModel.fromMap(Map<String, dynamic> map) => WalletModel(
    walletId: map[DBENV.instance.walletId] as int?,
    walletName: map[DBENV.instance.walletName] as String,
    walletBalance: map[DBENV.instance.walletBalance] as double,
    walletIcon: map[DBENV.instance.walletIcon] as Uint8List?,
    walletNote: map[DBENV.instance.walletNote] as String?,
    createdAt: map[DBENV.instance.createdAt] as String?,
    updatedAt: map[DBENV.instance.updatedAt] as String?,
  );

  Map<String, dynamic> toMap() => {
    DBENV.instance.walletName: walletName,
    DBENV.instance.walletBalance: walletBalance,
    DBENV.instance.walletIcon: walletIcon,
    DBENV.instance.walletNote: walletNote,
    DBENV.instance.walletOpen: walletOpen ? 1 : 0,
    DBENV.instance.createdAt: getDateTimeNow(),
    DBENV.instance.updatedAt: getDateTimeNow(),
  };

  Map<String, dynamic> toFirstCreateMap() => {
    DBENV.instance.walletId: walletId,
    DBENV.instance.walletName: walletName,
    DBENV.instance.walletBalance: walletBalance,
    DBENV.instance.walletIcon: walletIcon,
    DBENV.instance.walletNote: walletNote,
    DBENV.instance.walletOpen: walletOpen ? 1 : 0,
    DBENV.instance.createdAt: getDateTimeNow(),
    DBENV.instance.updatedAt: getDateTimeNow(),
  };

  Map<String, dynamic> toUpdateMap() => {
    DBENV.instance.walletName: walletName,
    DBENV.instance.walletBalance: walletBalance,
    DBENV.instance.walletIcon: walletIcon,
    DBENV.instance.walletNote: walletNote,
    DBENV.instance.walletOpen: walletOpen ? 1 : 0,
    DBENV.instance.updatedAt: getDateTimeNow(),
    DBENV.instance.createdAt: createdAt,
  };

  String getDateTimeNow() =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
