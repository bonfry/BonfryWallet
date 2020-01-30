import 'dart:convert';

import 'package:bonfry_wallet/data/database.dart';

class DatabaseManager{
  static Future<String>  backupDatabaseToJson() async{
    var dataMap = Map<String,List<Map<String,dynamic>>>();
    var db = await DatabaseContext.getDatabase();

    dataMap["money_transactions"] = await db.query("money_transactions");
    dataMap["money_budget"] = await db.query("money_budget");

    return json.encode(dataMap);
  }

  static Future<void> restoreDatabaseFromJson(String jsonText) async{
    var db = await DatabaseContext.getDatabase();
    var databaseBackup =  json.decode(jsonText);

    await db.delete("money_budget");
    
    for(var mBudget in databaseBackup["money_budget"]){
      await db.insert("money_budget", mBudget);
    }

    await db.delete("money_transactions");

    for(var mTransaction in databaseBackup["money_transactions"]){
      await db.insert("money_transactions", mTransaction);
    }
  }
}