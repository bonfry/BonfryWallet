import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  Database? _db;

  Future<Database> get database async {
    if (_db == null) {
      _db = await _initDatabase();
    }

    return _db!;
  }
}

Future<Database> _initDatabase() async {
  return openDatabase(join(await getDatabasesPath(), 'application_database.db'),
      version: 16, onCreate: (db, version) async {
    await db.execute(
      "CREATE TABLE money_budget("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "title TEXT, "
      "color Integer "
      ")",
    );

    await db.execute(
      "CREATE TABLE money_transactions("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "text TEXT, "
      "cost REAL, "
      "date INTEGER, "
      "transactionType Integer, "
      "transactionSign Integer, "
      "moneyBudgetId REFERENCES money_budget (id)"
      ")",
    );

    await db.rawUpdate(
      "UPDATE money_transactions "
      "SET moneyBudgetId = 0 where moneyBudgetId = NULL",
    );
    await db.rawInsert("INSERT INTO money_budget(id,title,color) values(?,?,?)",
        [0, "Budget principale", 4288585374]);
  }, onUpgrade: (db, oldVersion, newVersion) async {
    print("version $oldVersion , $newVersion ");

    if (oldVersion == 1) {
      return;
    }

    if (oldVersion < 11) {
      await db.execute(
        "CREATE TABLE money_budget("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title TEXT, "
        "color REAL "
        ")",
      );

      await db.execute(
        "ALTER TABLE money_transactions "
        "ADD COLUMN moneyBudgetId INTEGER REFERENCES money_budget(id);",
      );

      await db.rawUpdate(
        "UPDATE money_transactions "
        "SET moneyBudgetId = 0 where moneyBudgetId = NULL",
      );
    }

    if (oldVersion < 14) {
      await db.rawInsert(
        "INSERT INTO money_budget(id,title,color) values(?,?,?)",
        [0, "Budget principale", 4288585374],
      );
    }

    if (oldVersion < 16) {
      await db.execute(
        "ALTER TABLE money_transactions "
        "ADD COLUMN transactionSign INTEGER;",
      );
    }
  });
}
