import 'package:bonfry_wallet/data.dart';

class MoneyTransactionRepository {
  final MoneyTransactionApi transactionApi;

  MoneyTransactionRepository({
    this.transactionApi = const MoneyTransactionApi(),
  });

  Future<List<MoneyTransaction>> fetchTransactions() async {
    var transactionsRaw = await transactionApi.fetchTransactionsFromDb();

    var transactions =
        transactionsRaw.map((t) => MoneyTransaction.fromMap(t)).toList();

    return transactions;
  }

  Future<List<MoneyBudget>> fetchBudgets() async {
    var budgetsRaw = await transactionApi.fetchBudgetsFromDb();

    var budgets = budgetsRaw.map((b) => MoneyBudget.fromMap(b)).toList();

    return budgets;
  }

  Future<void> setTransaction(MoneyTransaction transaction) async {
    return transactionApi.setBudgetToDb(transaction.toMap());
  }

  Future<void> setBudget(MoneyBudget budget) async {
    return transactionApi.setBudgetToDb(budget.toMap());
  }

  Future<void> removeTransaction(int id) async {
    return transactionApi.removeTransactionToDb(id);
  }

  Future<void> removeBudget(int id) async {
    return transactionApi.removeBudgetToDb(id);
  }

  Future<void> backupDatabase() async {
    return transactionApi.backupDatabase();
  }

  Future<void> restoreDatabase() async {
    return transactionApi.restoreDatabase();
  }
}
