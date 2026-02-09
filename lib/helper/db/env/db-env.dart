class DBENV {
  static DBENV get instance => DBENV._contructor();
  DBENV._contructor();

  //
  //TABLE NAMES
  String databaseName = "expensave.db";

  //Tables and columns
  String walletTable = "wallet_table";
  //
  String walletId = "id";
  String walletName = "name";
  String walletIcon = "picture";
  String walletNote = "note";
  String walletBalance = "balance";
  String walletCurrency = "currency";
  String walletOpen = "isOpen";

  //===========================================================================
  String transactionTable = "transaction_table";
  //
  String transactionId = "id";
  String transactionIcon = "icon";
  String transactionAmount = "amount";
  String transactionNote = "note";
  String transactionType = "type";
  String transactionWalletId = "wallet_id";
  String transactionDate = "date";

  //==========================================================================
  //Common columns
  String updatedAt = "updatedAt";
  String createdAt = "createdAt";
}
