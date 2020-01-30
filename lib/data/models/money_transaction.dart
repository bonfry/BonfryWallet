import 'package:bonfry_wallet/data/database.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:sqflite/sqflite.dart';

import 'money_budget.dart';

class MoneyTransaction{
  int id;
  double amount;
  String text;
  DateTime date;
  int moneyBudgetId;
  MoneyBudget moneyBudget;
  MoneyTransactionType transactionType;

  MoneyTransaction({
    this.id,
    this.amount, 
    this.text, 
    this.date, 
    this.transactionType, 
    this.moneyBudgetId = 0,
    this.moneyBudget
  });
  
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "text":text,
      "cost":amount,
      "date":date.toIso8601String(),
      "transactionType": transactionType.index,
      "moneyBudgetId": moneyBudgetId
    };
  }
}


Future<void> addMoneyTransaction(MoneyTransaction moneyTx) async{
  Database database = await DatabaseContext.getDatabase();

  moneyTx.id = await database.insert('money_transactions', moneyTx.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
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
  final moneyBudgets = await getMoneyBudgetList();

  return moneyTransactionMaps.map((mtm){
    var moneyBudgetId = mtm["moneyBudgetId"] != null ? mtm["moneyBudgetId"] : 0;
    return MoneyTransaction(
        id: mtm["id"],
        amount: mtm["cost"],
        text: mtm["text"],
        transactionType: MoneyTransactionType.values[mtm["transactionType"]],
        date: DateTime.tryParse(mtm["date"]),
        moneyBudgetId: moneyBudgetId,
        moneyBudget: moneyBudgets.firstWhere((mb) => mb.id == moneyBudgetId)
    );
  }).toList();
}