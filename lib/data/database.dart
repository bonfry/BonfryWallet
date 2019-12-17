import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

Future<Database> importDatabase() async{
  return openDatabase(
    join(await getDatabasesPath(), 'application_database.db'),
    version: 5,
    onCreate: (db,version){
      db.execute(
      "CREATE TABLE money_transactions("+
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "+
        "text TEXT, "+
        "cost REAL, "+
        "date INTEGER, "+
        "transactionType Integer)",
      );
    }
  );
}


class DatabaseContext{
  static Future<Database> _db = importDatabase();

  static Future<Database> getDatabase() =>  _db;
}