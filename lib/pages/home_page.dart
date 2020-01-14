import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/models/money_budget.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';
import 'package:bonfry_wallet/helpers/amount_helpers.dart';
import 'package:bonfry_wallet/pages/settings_main_page.dart';
import 'package:bonfry_wallet/widgets/page-title.dart';
import 'package:bonfry_wallet/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';

import 'money_transaction_edit_page.dart';


class HomePage extends StatefulWidget{

  final List<MoneyTransaction> moneyTransactions;

  HomePage(this.moneyTransactions,{Key key}): super(key:key);

  @override
  _HomePageState createState() => _HomePageState(moneyTransactions);
}

class _HomePageState extends State<HomePage>{

  final globalKey = GlobalKey<ScaffoldState>(); 
  List<MoneyTransaction> moneyTransactions;
  
  _HomePageState(this.moneyTransactions);

  String getTotalAmount(){
    double totalAmount = 0;

    for(var t in moneyTransactions){
      totalAmount += t.transactionType == MoneyTransactionType.received ?
        t.amount : (-1)*t.amount;   
    }

    return getAmountStringFormatted(totalAmount);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Bonfry Wallet"),
        backgroundColor: Colors.indigo[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async{
              bool needtoResetTransition = await Navigator.push(context, MaterialPageRoute(builder: (builder) => SettingsPage()));
            
              if(needtoResetTransition){
                setState(() {
                  moneyTransactions.clear();
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
          TitleWidget("Budget Attuale"),
            Container(
              child: Column(
                children: <Widget>[
                  Center(child: Text("${getTotalAmount()}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 45),)),
                ],
              ),
            ),
            TitleWidget("Transazioni effettuate"),
            Column(
              children: buildListTiles(context),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{

          List<MoneyBudget> budgetListToSend = await getMoneyBudgetList();          

          var response = await goToMoneyTransactionEdit(context:context, budgets:budgetListToSend);

          if(response.responseType == MoneyTransactionEditResponseType.created){
            setState(() {
              moneyTransactions.add(response.data);
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
            padding: EdgeInsets.symmetric(horizontal: 4 ),
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red[900],
            child: Icon(Icons.delete, color: Colors.white,size: 35,)
          ),
          child: GestureDetector(
            onTap: () async {

              List<MoneyBudget> budgetListToSend = await getMoneyBudgetList();          
              
              var response = await goToMoneyTransactionEdit(context:context, budgets:budgetListToSend,transaction: t);

              if(response.responseType == MoneyTransactionEditResponseType.updated){
                setState(() {
                  t = response.data;
                });
              }else if(response.responseType == MoneyTransactionEditResponseType.removed){
                setState(() {
                  moneyTransactions.remove(t);
                });
              }
            },
            child: TransactionListItem(t),
          )
        );
      }).toList();
  }
}
