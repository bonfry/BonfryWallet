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
}
