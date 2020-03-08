import 'package:bonfry_wallet/data/database_migration.dart';
import 'package:bonfry_wallet/data/model/model.dart';
import 'package:bonfry_wallet/widgets/PageNavigator.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('images/splash_logo.png'), context);
    precacheImage(AssetImage('images/splash_name_logo.png'), context);
    precacheImage(AssetImage('images/home_icon.png'), context);

    Future.delayed(
        Duration(seconds: 1),
        () => BonfryWalletModel()
            .initializeDB()
            .then((value) => migrateToOrm())
            .then((val) => getMoneyTransactionsFromDb())
            .then((value) => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) => PageNavigator()))));

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(80),
              child: Image(image: AssetImage('images/splash_logo.png')),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: SizedBox(
                height: 45.0,
                width: 45.0,
                child: CircularProgressIndicator(strokeWidth: 4)),
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 35, horizontal: 120),
            child: Image(image: AssetImage('images/splash_name_logo.png')),
          ))
        ],
      ),
    );
  }
}

Future<List> getMoneyTransactionsFromDb() async {
  var moneyBudgetsList = await MoneyBudget().select().toList();

  if (moneyBudgetsList.length == 0) {
    var moneyBudget = MoneyBudget(
        id: 0, title: "Budget principale", color: Colors.grey.value);

    var result = await moneyBudget.save();
    print(result);

    moneyBudgetsList.add(moneyBudget);
  }

  return moneyBudgetsList;
}
