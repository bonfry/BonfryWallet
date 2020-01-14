import 'package:bonfry_wallet/data/database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MoneyBudget{
  int id;
  String title;
  Color color;

  MoneyBudget({
    this.id,
    this.title,
    this.color,
  });

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "title": title,
      "color": color.value
    };
  }
}

Future<MoneyBudget> findMoneyBudgetById(int id) async{
  Database database = await DatabaseContext.getDatabase();

  var result = await database.query(
    'money_budget', 
    where:"id= ? ",
    whereArgs: [id]);

  if(result.length != 1){
    return null;
  }

  return MoneyBudget(
    id: result[0]["id"],
    title: result[0]["title"],
    color: Color(result[0]["color"].round())
  );
}

Future<void> addMoneyBudget(MoneyBudget budget) async {
  Database database = await DatabaseContext.getDatabase();

  budget.id = await database.insert('money_budget', budget.toMap());

}

Future<void> removeMoneyBudget(int id) async {
  Database database = await DatabaseContext.getDatabase();
  
  await database.delete(
    'money_transactions',
    where: "moneyBudgetId = ?",
    whereArgs: [id]
  );
  
  await database.delete(
    'money_budget',
    where: "id = ?",
    whereArgs: [id]);
}

Future<void> updateMoneyBudget(MoneyBudget budget) async {
  Database database = await DatabaseContext.getDatabase();

  await database.update(
    'money_budget', 
    budget.toMap(),
    where: "id = ?",
    whereArgs: [budget.id]);
}

Future<List<MoneyBudget>> getMoneyBudgetList() async{
  Database database = await DatabaseContext.getDatabase();

  final List<Map<String, dynamic>> moneyBudgetsListMap = await database.query('money_budget');

  return moneyBudgetsListMap.map((mb) => MoneyBudget(
    id: mb["id"],
    title: mb["title"],
    color: Color(mb["color"].round())
  )).toList();

} 

