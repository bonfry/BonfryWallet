import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

import 'package:sqflite/sqflite.dart';
import 'package:bonfry_wallet/data/database.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/pages/new_money_transaction_page.dart';
import 'package:bonfry_wallet/widgets/page-title.dart';

import 'data/models/money_transaction.dart';


void main(){
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portafoglio personale',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  BuildContext context;


  List<MoneyTransaction> transactions = [];
  double totalMoney = 0;


  num getTotal(){
    num total = 0;

    transactions.forEach((t){
      total += t.transactionType == MoneyTransactionType.received ? 
        t.cost : (-1)*t.cost;
    });

    return total;
  }

  //final Future<Database> database = openDatabase(join(await getDatabasePath(), 'money_transations.db');

  Widget _buildSuggestions() {
    List<Widget> widgetList = [];

    for(MoneyTransaction t in transactions){
      widgetList.add(_buildRow(t));

      if(transactions.indexOf(t) < transactions.length -1){
        widgetList.add(Divider(color: Colors.grey,height: 2,));    
      }
    }

    return Column(
      children: widgetList,
    );
  }

  Widget _buildRow(MoneyTransaction t) {
    String transactionSimbol = t.transactionType == MoneyTransactionType.received? "+":"-";

    return Dismissible(
      key: Key(transactions.indexOf(t).toString()),
      onDismissed: (direction){
        Future.wait([removeMoneyTransaction(t.id)]);

        setState(() {
          transactions.remove(t);
        });

        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Transazione rimossa con successo"))
        );
      },
      background: Container(color: Colors.red[800]),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              child:Container(
                padding: EdgeInsets.only(left:10,right:15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("IN ENTRATA"),
                    Text(
                      "Transazione effettuata!",
                      textAlign : TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ) 
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 10,top: 15,right: 10, bottom: 15),
              child: Column(
                children: <Widget>[
                  Text("${new DateFormat('d MMM y').format(t.date).toUpperCase()}"),
                  Text(
                    "$transactionSimbol 1200 €",
                    style: TextStyle(
                      fontWeight:FontWeight.w600,
                      fontSize: 22,
                      color: t.transactionType == MoneyTransactionType.received ?Colors.green[800]: Colors.red[800] 
                    )
                  )
                ],
              )
            ),
          ],
        ),
      )
    );
  }

  void removeAllMoneyTransaction(){
    DatabaseContext.getDatabase().then((Database db) async{
      int changes = await  db.rawDelete("DELETE FROM money_transactions WHERE 1=1");

      print("Rimozioni effettuate --> $changes");

      if(changes == transactions.length){
        setState(() {
          transactions = new List<MoneyTransaction>();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    getTransactionList().then((txList){
      setState(() {
        transactions = txList;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Bonfry Wallet"),
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
        ]
      ),
      body: ListView(
        children: <Widget>[
          TitleWidget("Bugdet Attuale"),
          Container(
            child: Column(
              children: <Widget>[
                Center(child: Text("${getTotal().toStringAsFixed(2)} €",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 45),)),
              ],
            ),
          ),
          TitleWidget("Transazioni effettuate"),
          Container(
            child: _buildSuggestions(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (builder) => NewMoneyTransactionPage())
          ).then((val){
            if(val != null && val.runtimeType == MoneyTransaction){
              setState(() {
                transactions.add(val);
              });
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[900],
      ),
    );
  }
}
