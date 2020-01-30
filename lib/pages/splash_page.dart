import 'package:bonfry_wallet/data/models/money_budget.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';
import 'package:bonfry_wallet/pages/home_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget{

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>{

  @override
  Widget build(BuildContext context){
    precacheImage( AssetImage('images/splash_logo.png'), context);
    precacheImage( AssetImage('images/splash_name_logo.png'), context);


    Future.delayed(Duration(seconds: 10),() async {
        List<MoneyTransaction> transactions = await getTransactionList();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => HomePage(transactions)));
    });

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child:Padding(
              padding: EdgeInsets.all(80),
              child: Image(image:  AssetImage('images/splash_logo.png')),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: SizedBox(
              height: 45.0,
              width: 45.0,
              child:  CircularProgressIndicator(
                strokeWidth: 4
              )
            ),
          ),
          Center(
            child:Padding(
              padding: EdgeInsets.symmetric(vertical: 35, horizontal: 120),
              child: Image(image:AssetImage('images/splash_name_logo.png')),
            )
          )
        ],
      ),
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

  return await getTransactionList();
}
