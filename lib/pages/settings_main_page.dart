import 'package:bonfry_wallet/data/database.dart';
import 'package:bonfry_wallet/pages/settings_budget_page.dart';
import 'package:bonfry_wallet/widgets/option_element_list.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'backup_restore_page.dart';
import 'credits_page.dart';


class SettingsPage extends StatefulWidget{

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage>{
  bool mustResetTransaction = false;

  static GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();

  final List<OptionElement> options = <OptionElement>[
    OptionElement(
      "Cancella tutte le transazioni",
      subText: "Elimina in un colpo solo",
      icon:Icons.delete_forever, 
      callback: (BuildContext context) => 
        _deleteAllTransactionCb(context,scaffoldKey)
      ),
    OptionElement(
      "Budget inseriti",
      subText: "Per modificare i tuoi budget",
      icon:Icons.account_balance_wallet, 
      callback:(BuildContext context){
       Navigator.push(context, MaterialPageRoute(builder: (builder) => BudgetSettingsPage()));
    }),
    OptionElement(
        "Backup e ripristino",
        subText: "Salva e ripristina i tuoi dati nel modo che preferisci",
        icon:Icons.restore,
        callback:(BuildContext context){
          Navigator.push(context, MaterialPageRoute(builder: (builder) => BackupRestorePage()));
        }),
    OptionElement(
        "Info & Crediti",
        subText: "Informazioni su Bonfry Wallet",
        icon:Icons.info,
        callback:(BuildContext context){
          Navigator.push(context, MaterialPageRoute(builder: (builder) => CreditsPage()));
        }),

  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context,mustResetTransaction);
          }
        ),
        backgroundColor: Colors.indigo[700],
        title: Text("Impostazioni"),
      ),
      body:
      OptionElementList(
          children: options,
          onChildTap: (context,index){
            if(index == 0){
              mustResetTransaction = true;
            }
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