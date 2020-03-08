import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/model.dart';

Future migrateToOrm() async {
  var dbPath = join(await getDatabasesPath(), 'application_database.db');
  var dbFile = File(dbPath);

  if (!await dbFile.exists()) {
    return;
  }

  Database oldDb = await _importOldDatabase();

  var budgets = await oldDb
      .query('money_budget')
      .then((budgets) => budgets.map((b) => MoneyBudget(
            id: b['id'],
            color: b['color'],
            title: b['title'],
          )));

  await MoneyBudget().saveAll(budgets);

  var transactions = await oldDb.query('money_transactions').then(
      (transactions) => transactions.map((t) => MoneyTransaction(
          id: t['id'],
          import: t['cost'],
          date: DateTime(t['date']),
          moneyBudgetId: t['moneyBudgetId'],
          transactionType: t['transactionType'],
          title: t['title'])));

  await MoneyTransaction().saveAll(transactions);

  await dbFile.delete();
}

Future<Database> _importOldDatabase() async {
  return openDatabase(join(await getDatabasesPath(), 'application_database.db'),
      version: 15, onCreate: (db, version) async {
    await db.execute("CREATE TABLE money_budget(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "title TEXT, " +
        "color Integer )");

    await db.execute("CREATE TABLE money_transactions(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "text TEXT, " +
        "cost REAL, " +
        "date INTEGER, " +
        "transactionType Integer, " +
        "moneyBudgetId REFERENCES money_budget (id))");

    await db.rawUpdate(
        "UPDATE money_transactions SET moneyBudgetId = 0 where moneyBudgetId = NULL");
    await db.rawInsert("INSERT INTO money_budget(id,title,color) values(?,?,?)",
        [0, "Budget principale", 4288585374]);
  }, onUpgrade: (db, oldVersion, newVersion) async {
    print("version $oldVersion , $newVersion ");

    if (oldVersion == 1) {
      return;
    }

    if (oldVersion < 11) {
      await db.execute("CREATE TABLE money_budget(" +
          "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
          "title TEXT, " +
          "color REAL )");

      await db.execute(
        "ALTER TABLE money_transactions ADD COLUMN moneyBudgetId INTEGER REFERENCES money_budget(id);",
      );

      await db.rawUpdate(
          "UPDATE money_transactions SET moneyBudgetId = 0 where moneyBudgetId = NULL");
    }

    if (oldVersion < 14) {
      await db.rawInsert(
          "INSERT INTO money_budget(id,title,color) values(?,?,?)",
          [0, "Budget principale", 4288585374]);
    }
  });
}
