import 'package:bonfry_wallet/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'data/models/money_budget.dart';
import 'data/models/money_transaction.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var moneyTransactions =  await getMoneyTransactionsFromDb();
  return runApp(MyApp(moneyTransactions:moneyTransactions));
}

class MyApp extends StatelessWidget {

  final List<MoneyTransaction> moneyTransactions;

  const MyApp({Key key, this.moneyTransactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonfry Wallet',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(moneyTransactions),
    );
  }
}


  Future<List> getMoneyTransactionsFromDb() async{
    var moneyBudgetsList = await getMoneyBudgetList();

    if(moneyBudgetsList.length == 0){
      moneyBudgetsList.add(MoneyBudget(
        id:0,
        title: "Budget principale",
        color: Colors.grey
      ));

      await addMoneyBudget(moneyBudgetsList[0]);
    }

    return await getTransactionList().then((tList){
      return tList.map((t){
        t.moneyBudget = moneyBudgetsList
          .firstWhere((b) => t.moneyBudgetId == b.id);
          return t;
        }).toList();
    });
  }
