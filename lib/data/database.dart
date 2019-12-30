import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

Future<Database> importDatabase() async{
  return openDatabase(
    join(await getDatabasesPath(), 'application_database.db'),
    version: 14,
    onCreate: (db,version) async{
      await db.execute(
        "CREATE TABLE money_budget("+
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "+
          "title TEXT, "+
          "color Integer )"
        );

      await db.execute(
        "CREATE TABLE money_transactions("+
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "+
        "text TEXT, "+
        "cost REAL, "+
        "date INTEGER, "+
        "transactionType Integer, "+
        "moneyBudgetId REFERENCES money_budget (id))"
      );

      await db.rawUpdate("UPDATE money_transactions SET moneyBudgetId = 0 where moneyBudgetId = NULL");
      await db.rawInsert("INSERT INTO money_budget(id,title,color) values(?,?,?)",[0,"Budget principale",4288585374]);

    },
    onUpgrade: (db, oldVersion, newVersion) async{
      if(oldVersion < 11)  {
        await db.execute(
         "CREATE TABLE money_budget("+
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "+
          "title TEXT, "+
          "color REAL )"
        );
       
        await db.execute(
          "ALTER TABLE money_transactions ADD COLUMN moneyBudgetId INTEGER REFERENCES money_budget(id);",
        );

        await db.rawUpdate("UPDATE money_transactions SET moneyBudgetId = 0 where moneyBudgetId = NULL");
      }

      if(oldVersion < 14){
         await db.rawInsert("INSERT INTO money_budget(id,title,color) values(?,?,?)",[0,"Budget principale",4288585374]);
      }
    }
  );
  
}


class DatabaseContext{
  static Future<Database> _db = importDatabase();

  static Future<Database> getDatabase() =>  _db;
}