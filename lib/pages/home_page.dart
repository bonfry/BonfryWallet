import 'package:bonfry_wallet/data/database.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/models/money_budget.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';
import 'package:bonfry_wallet/widgets/page-title.dart';
import 'package:bonfry_wallet/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'new_money_transaction_page.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key}): super(key:key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final globalKey = GlobalKey<ScaffoldState>(); 
  List<MoneyTransaction> moneyTransactions;

  Future<bool> getMoneyTransactionsFromDb() async{
    var moneyBudgetsList = await getMoneyBudgetList();

      if(moneyBudgetsList.length == 0){
        moneyBudgetsList.add(MoneyBudget(
          id:0,
          title: "Bugget principale",
          color: Colors.grey
        ));

        await addMoneyBudget(moneyBudgetsList[0]);
      }

      this.moneyTransactions = await getTransactionList().then((tList){
        return tList.map((t){
          t.moneyBudget = moneyBudgetsList
            .firstWhere((b) => t.moneyBudgetId == b.id);
            return t;
          }).toList();
      });

      return Future<bool>.delayed(Duration(seconds:3),() => true);
  }

  double getTotalAmount(){
    double totalAmount = 0;

    for(var t in moneyTransactions){
      totalAmount += t.transactionType == MoneyTransactionType.received ?
        t.cost : (-1)*t.cost;   
    }

    return totalAmount;
  }

  void removeAllMoneyTransaction(){
    DatabaseContext.getDatabase().then((Database db) async{
      int changes = await  db.rawDelete("DELETE FROM money_transactions WHERE 1=1");

      if(changes == moneyTransactions.length){
        setState(() {
          moneyTransactions = new List<MoneyTransaction>();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<bool>(
      future: getMoneyTransactionsFromDb(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.hasData && snapshot.data ){
          return Scaffold(
            key: globalKey,
            body: Builder(
              builder: buildSuccessfulScaffold,
            )
          );
        }else{
          return waitingLoadScaffold();
        }
      },
    );
  }

  Widget buildSuccessfulScaffold(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Bonfry Wallet"),
        backgroundColor: Colors.indigo[900],
        actions: <Widget>[
          PopupMenuButton(
           itemBuilder: (BuildContext context) => 
            <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 0,
                child: Text("Cancella tutte le transazioni"),
              )
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (num option){
              switch(option){
                case 0:
                removeAllMoneyTransaction();
                break;
              }
            },
          )
        ],
      ),
      body: ListView(children: <Widget>[
         TitleWidget("Bugdet Attuale"),
          Container(
            child: Column(
              children: <Widget>[
                Center(child: Text("${getTotalAmount().toStringAsFixed(2)} €",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 45),)),
              ],
            ),
          ),
          TitleWidget("Transazioni effettuate"),
          Column(
            children: buildListTiles(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{

          List<MoneyBudget> budgetListToSend = await getMoneyBudgetList();          

          MoneyTransaction newMoneyTransaction = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (builder) => NewMoneyTransactionPage(budgetListToSend))
          );

          if(newMoneyTransaction != null){
            setState(() {
              moneyTransactions.add(newMoneyTransaction);
            });
          }
          
        },
      ),
    );
  }

  List<Widget> buildListTiles(BuildContext context){
    return moneyTransactions.map((t){
        return Dismissible(
          key: Key(moneyTransactions.indexOf(t).toString()),
          confirmDismiss: (DismissDirection direction) async {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Conferma"),
                  content: const Text("Vuoi eliminare questa transazione?"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        await removeMoneyTransaction(t.id);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("CANCELLA")
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("ANNULLA"),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) async{
            setState(() {
              moneyTransactions.remove(t);
            });

            globalKey.currentState.showSnackBar(SnackBar(content: Text("Elemento eliminato"),));
          },
          direction: DismissDirection.endToStart,
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 10 ),
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red[800],
            child: Icon(Icons.delete, color: Colors.white,size: 35,)
          ),
          child: TransactionListItem(t)
        );
      }).toList();
  }
}

Widget waitingLoadScaffold(){
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          Text(
            "Sto caricando le transazioni...", 
            style: TextStyle(fontSize: 22)
          )
        ],
      ),
    ),
  );
}