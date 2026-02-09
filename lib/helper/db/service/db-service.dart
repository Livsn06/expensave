import 'dart:developer';

import 'package:expensave/helper/db/env/db-env.dart';
import 'package:expensave/models/transaction_model.dart';
import 'package:expensave/models/wallet_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static final DBService instance = DBService._internal();
  DBService._internal();

  //
  Future<Database> openMyDatabase() async {
    final dbPath = await getDatabasesPath();

    final database = await openDatabase(
      join(dbPath, DBENV.instance.databaseName),
      version: 1,
      onCreate: (db, version) async {
        await createWalletDB(db);
        await createTransactionDB(db);
      },

      //
      onUpgrade: (db, oldVersion, newVersion) async {
        if (newVersion > oldVersion) {
          await createWalletDB(db);
          await createTransactionDB(db);
        }
      },
    );
    return database;
  }

  // create Table
  Future<void> createWalletDB(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE ${DBENV.instance.walletTable} (
        ${DBENV.instance.walletId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBENV.instance.walletName} TEXT NOT NULL,
        ${DBENV.instance.walletBalance} REAL NOT NULL DEFAULT 0.0,
        ${DBENV.instance.walletIcon} BLOB,
        ${DBENV.instance.walletNote} TEXT,
        ${DBENV.instance.walletCurrency} TEXT,
        ${DBENV.instance.walletOpen} INTEGER NOT NULL DEFAULT 0,
        ${DBENV.instance.updatedAt} TEXT,
        ${DBENV.instance.createdAt} TEXT
      )
    ''');

      log('Wallet table created successfully');
    } catch (e) {
      log('Error creating wallet table: $e');
    }
  }

  Future<void> createTransactionDB(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE ${DBENV.instance.transactionTable} (
        ${DBENV.instance.transactionId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBENV.instance.transactionAmount} REAL NOT NULL,
        ${DBENV.instance.transactionNote} TEXT,
        ${DBENV.instance.transactionType} TEXT,
        ${DBENV.instance.transactionIcon} TEXT,
        ${DBENV.instance.transactionWalletId} INTEGER NOT NULL,
        ${DBENV.instance.transactionDate} TEXT NOT NULL,
        ${DBENV.instance.createdAt} TEXT
      )
    ''');

      log('Transaction table created successfully');
    } catch (e) {
      log('Error creating transaction table: $e');
    }
  }

  //============================================================================
  Future<void> deleteDB() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, DBENV.instance.databaseName);
      await deleteDatabase(path);
      log('Database deleted successfully');
    } catch (e) {
      log('Error deleting database: $e');
    }
  }

  //============================================================================

  Future<bool> checkCurrentWallet() async {
    final db = await openMyDatabase();
    final wallet = await db.query(DBENV.instance.walletTable);
    return wallet.isNotEmpty;
  }

  Future<WalletModel?> getOpenWallet() async {
    final db = await openMyDatabase();

    final List<Map<String, dynamic>> results = await db.query(
      DBENV.instance.walletTable,
      where: '${DBENV.instance.walletOpen} = ?',
      whereArgs: [1],
      limit: 1,
    );
    await db.close();

    if (results.isNotEmpty) {
      return WalletModel.fromMap(results.first);
    } else {
      return null;
    }
  }

  //============================================================================

  Future<void> createFirstWallet(WalletModel wallet) async {
    wallet = wallet.copyWith(walletOpen: true, walletId: 1);

    final db = await openMyDatabase();
    try {
      await db.insert(DBENV.instance.walletTable, wallet.toFirstCreateMap());
      await db.close();
      log('Wallet created successfully');
    } catch (e) {
      await db.close();
      log('Error creating wallet: $e');
    }
  }

  Future<int?> createWallet(WalletModel wallet) async {
    final db = await openMyDatabase();
    try {
      final id = await db.insert(DBENV.instance.walletTable, wallet.toMap());

      await db.close();
      log('Wallet created successfully');
      if (id == 0) return null;
      return id;
    } catch (e) {
      await db.close();
      log('Error creating wallet: $e');
      return null;
    }
  }

  //

  Future<void> updateWallet(int walletId, WalletModel wallet) async {
    final db = await openMyDatabase();
    try {
      await db.update(
        DBENV.instance.walletTable,
        wallet.toUpdateMap(),
        where: '${DBENV.instance.walletId} = ?',
        whereArgs: [walletId],
      );
      await db.close();
      log('Wallet updated successfully');
    } catch (e) {
      await db.close();
      log('Error updating wallet: $e');
    }
  }

  //

  Future<void> deleteWallet(int walletId) async {
    final db = await openMyDatabase();
    try {
      await db.delete(
        DBENV.instance.walletTable,
        where: '${DBENV.instance.walletId} = ?',
        whereArgs: [walletId],
      );
      await db.close();
      log('Wallet deleted successfully');
    } catch (e) {
      await db.close();
      log('Error deleting wallet: $e');
    }
  }

  //

  Future<void> addTransaction(TransactionModel transaction) async {
    final db = await openMyDatabase();
    try {
      await db.insert(DBENV.instance.transactionTable, transaction.toMap());
      await db.close();
      log('Transaction added successfully');
    } catch (e) {
      await db.close();
      log('Error adding transaction: $e');
    }
  }

  //

  Future<List<TransactionModel>> getWalletTransactions(int walletId) async {
    final db = await openMyDatabase();
    try {
      final transactions = await db.query(
        DBENV.instance.transactionTable,
        where: '${DBENV.instance.transactionWalletId} = ?',
        whereArgs: [walletId],
        orderBy: '${DBENV.instance.createdAt} DESC',
      );
      await db.close();
      log('Transactions retrieved successfully');
      return transactions.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      await db.close();
      log('Error getting transactions: $e');
      return [];
    }
  }

  Future<void> deleteWalletTransactions(int walletId) async {
    final db = await openMyDatabase();
    try {
      await db.delete(
        DBENV.instance.transactionTable,
        where: '${DBENV.instance.transactionWalletId} = ?',
        whereArgs: [walletId],
      );
      await db.close();
      log('Transaction deleted successfully');
    } catch (e) {
      await db.close();
      log('Error deleting transaction: $e');
    }
  }

  //

  Future<List<WalletModel>> getAllWallet() async {
    final db = await openMyDatabase();
    try {
      final wallets = await db.query(DBENV.instance.walletTable);

      await db.close();
      log('Wallets retrieved successfully');
      return wallets.map((e) => WalletModel.fromMap(e)).toList();
    } catch (e) {
      await db.close();
      log('Error getting wallets: $e');
      return [];
    }
  }

  Future<WalletModel?> getRecentlyOpenedWallet() async {
    final db = await openMyDatabase();

    final now = DateTime.now();
    final fullDatetimeFormat = DateFormat('yyyy-MM-dd');

    List<Map<String, dynamic>> results = await db.query(
      DBENV.instance.walletTable,
      limit: 1,
      orderBy: '${DBENV.instance.updatedAt} DESC',
    );

    await db.close();

    if (results.isNotEmpty) {
      final firstWalletMap = results.first;

      final String storedDateString =
          firstWalletMap[DBENV.instance.updatedAt] as String;
      try {
        final DateTime storedDateTime = fullDatetimeFormat.parse(
          storedDateString,
        );
        if (storedDateTime.year == now.year &&
            storedDateTime.month == now.month &&
            storedDateTime.day == now.day) {
          return WalletModel.fromMap(firstWalletMap);
        }
      } catch (e) {
        log('Error parsing stored date string: $e');
      }
    }

    return null;
  }
}
