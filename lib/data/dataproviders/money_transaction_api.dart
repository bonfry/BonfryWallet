import 'dart:convert';

import 'package:bonfry_wallet/data/dataproviders.dart';
import 'package:sqflite/sqlite_api.dart';

///Api per gestire le transazioni
class MoneyTransactionApi {
  const MoneyTransactionApi();

  ///Permette di scaricare le transazioni dal db
  Future<List<Map<String, dynamic>>> fetchTransactionsFromDb() async {
    var db = await DatabaseManager().database;

    var queriesResults = await Future.wait([
      db.query('money_budget'),
      db.query('money_transactions'),
    ]);

    var budgets = queriesResults.first;
    var transactions = queriesResults.first;

    var transactionsWithBudgets = transactions.map((t) {
      var tx = Map<String, dynamic>.from(t);
      tx['budget'] = budgets.singleWhere((b) => b['id'] == tx['moneyBudgetId']);
      return tx;
    }).toList();

    return transactionsWithBudgets;
  }

  Future<List<Map<String, dynamic>>> fetchBudgetsFromDb() async {
    var db = await DatabaseManager().database;

    var result = await db.query('money_budget');
    return result;
  }

  Future<void> setTransactionToDb(Map<String, dynamic> transaction) async {
    var db = await DatabaseManager().database;

    await db.insert(
      'money_transactions',
      transaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setBudgetToDb(Map<String, dynamic> budget) async {
    var db = await DatabaseManager().database;

    await db.insert(
      'money_budget',
      budget,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeTransactionToDb(int id) async {
    var db = await DatabaseManager().database;

    await db.delete(
      'money_transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> removeBudgetToDb(int id) async {
    var db = await DatabaseManager().database;

    await db.delete(
      'money_budget',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> backupDatabase() async {
    var db = await DatabaseManager().database;

    var jsonEntities = await Future.wait([
      db.query('money_budget'), //0
      db.query('money_transactions'), //1
    ]);

    var backupMap = {
      'money_budget': jsonEntities[0],
      'money_transactions': jsonEntities[1],
    };

    //TODO: implementare salvataggio file
  }

  Future<void> restoreDatabase() async {
    var db = await DatabaseManager().database;

    //TODO: implementare caricamento file

    Map<String, List<Map<String, dynamic?>>> mapEntities = {};

    await db.transaction((txn) async {
      //foreach per le tabelle
      for (var entry in mapEntities.entries) {
        //foreach per le righe
        for (var entity in entry.value) {
          await txn.insert(
            entry.key, // nome tabella
            entity, // riga della tabella
          );
        }
      }

      return;
    });
  }
}
