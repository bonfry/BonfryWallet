import 'package:bonfry_wallet/data/database.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'money_budget.dart';

class MoneyTransaction{
  final int id;
  double cost;
  String text;
  final DateTime date;
  int moneyBudgetId;
  MoneyBudget moneyBudget;
  MoneyTransactionType transactionType;

  MoneyTransaction({
    this.id,
    @required this.cost, 
    this.text, 
    @required this.date, 
    @required this.transactionType, 
    this.moneyBudgetId = 0
  });
  
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "text":text,
      "cost":cost,
      "date":date.toIso8601String(),
      "transactionType": transactionType.index,
      "moneyBudgetId": moneyBudgetId
    };
  }
}


Future<void> addMoneyTransaction(MoneyTransaction moneyTx) async{
  Database database = await DatabaseContext.getDatabase();

  await database.insert('money_transactions', moneyTx.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> removeMoneyTransaction(int id) async{
   final db = await DatabaseContext.getDatabase();

  await db.delete(
    'money_transactions', 
    where: "id = ?",
    whereArgs: [id]
  );
}

Future<void> updateMoneyTransaction(MoneyTransaction moneyTx) async{
  final db = await DatabaseContext.getDatabase();

  await db.update(
    'money_transactions', 
    moneyTx.toMap(),
    where: "id = ?",
    whereArgs: [moneyTx.id]
  );
}

Future<List<MoneyTransaction>> getTransactionList() async {
  final db = await DatabaseContext.getDatabase();

  final List<Map<String, dynamic>> moneyTransactionMaps = await db.query('money_transactions');

  return moneyTransactionMaps
    .map((mtm) => MoneyTransaction(
      id: mtm["id"],
      cost: mtm["cost"],
      text: mtm["text"],
      transactionType: MoneyTransactionType.values[mtm["transactionType"]],
      date: DateTime.tryParse(mtm["date"]),
      moneyBudgetId: mtm["moneyBudgetId"]
    )).toList();
}