import 'dart:convert';

import 'model/model.dart';

class DataBackupManager {
  static Future<String> backupDatabaseToJson() async {
    var dataMap = Map<String, List<Map<String, dynamic>>>();

    dataMap["money_transactions"] =
        await MoneyTransaction().select().toMapList();
    dataMap["money_budget"] = await MoneyBudget().select().toMapList();

    return json.encode(dataMap);
  }

  static Future<void> restoreDatabaseFromJson(String jsonText) async {
    jsonText.replaceAll('cost', 'import');

    var databaseBackup = json.decode(jsonText);

    await MoneyTransaction().delete(true);
    MoneyTransaction.fromMapList(databaseBackup['money_transactions']);

    await MoneyBudget().delete(true);
    MoneyTransaction.fromMapList(databaseBackup['money_budget']);
  }
}
