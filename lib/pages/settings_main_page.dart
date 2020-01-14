import 'package:bonfry_wallet/data/database.dart';
import 'package:bonfry_wallet/pages/settings_budget_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'credits_page.dart';


typedef VoidCallbackWithContext = void Function(BuildContext);

class _OptionElement{
  final VoidCallbackWithContext callback;
  final String text;
  final String subText;
  IconData icon;

  _OptionElement(this.text,{this.callback, this.icon, this.subText,});
}

class SettingsPage extends StatefulWidget{

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage>{
  bool hasResettedTransactions = false;

  static GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();

  final List<_OptionElement> options = <_OptionElement>[
    _OptionElement(
      "Cancella tutte le transazioni",
      subText: "Elimina in un colpo solo",
      icon:Icons.delete_forever, 
      callback: (BuildContext context) => 
        _deleteAllTransactionCb(context,scaffoldKey)
      ),
    _OptionElement(
      "Budget inseriti",
      subText: "Per modificare i tuoi budget",
      icon:Icons.account_balance_wallet, 
      callback:(BuildContext context){
       Navigator.push(context, MaterialPageRoute(builder: (builder) => BudgetSettingsPage()));
    }),
    _OptionElement(
      "Info & Crediti",
      subText: "Informazioni su Bonfry Wallet",
      icon:Icons.info, 
      callback:(BuildContext context){
       Navigator.push(context, MaterialPageRoute(builder: (builder) => CreditsPage()));
    })
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context,hasResettedTransactions);
          }
        ),
        backgroundColor: Colors.indigo[700],
        title: Text("Impostazioni"),
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index){
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            leading: options[index].icon != null? Container(
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.indigo[700],
                shape: BoxShape.circle
              ),
              child: Icon(options[index].icon,color: Colors.white,),
            ): null,
            title: Text(options[index].text,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
            subtitle:  Text(options[index].subText),
            onTap: (){
              options[index].callback(context);

              if(index == 0){
                hasResettedTransactions = true;
              }
            },
          );
        },
      )
    );
  }
}

  void _deleteAllTransactionCb(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async{
 
    var isConfimed = await _showConfirmRemoveDialog(context);
    
    try{
        if(isConfimed){
          await DatabaseContext.getDatabase()
            .then((Database db) => db.rawDelete("DELETE FROM money_transactions WHERE 1=1"));

            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Rimosse tutte le tranzazioni con successo!"),));
        }
    }catch(e){}
  }


Future<bool> _showConfirmRemoveDialog(BuildContext context) {
        // flutter defined function
        return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Cancellazione transazioni"),
              content: new Text("Sei sicuro di voler cancellare le transazioni registrate"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Conferma"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                new FlatButton(
                  child: new Text("Chiudi"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      }