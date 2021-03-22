import 'package:bonfry_wallet/data/dataproviders.dart';

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
}
