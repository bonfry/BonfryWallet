import 'package:bonfry_wallet/data/database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


typedef VoidCallbackWithContext = void Function(BuildContext);

class _OptionElement{
  final VoidCallbackWithContext callback;
  final String text;
  IconData icon;

  _OptionElement(this.text,{this.callback, this.icon} );
}

class SettingsPage extends StatelessWidget{

  final List<_OptionElement> options = <_OptionElement>[
    _OptionElement("Cancella tutte le transazioni",icon:Icons.delete_forever, callback: (BuildContext context) async{
       
       var isConfimed = await _showConfirmRemoveDialog(context);
       
       try{
            if(isConfimed){
              await DatabaseContext.getDatabase()
                .then((Database db) => db.rawDelete("DELETE FROM money_transactions WHERE 1=1"));
            }
        }catch(e){}
      
    }),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text("Impostazioni"),
      ),
      body: ListView.separated(
        itemCount: options.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: options[index].icon != null? Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                shape: BoxShape.circle
              ),
              child: Icon(options[index].icon,color: Colors.white,),
            ): null,
            title: Text(options[index].text),
            onTap: () => options[index].callback(context),
          );
        },
        separatorBuilder: (context, index){
          return Divider(color: Colors.black,);
        },
      )
    );
  }
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
                  child: new Text("Si"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      }