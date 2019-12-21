import 'package:flutter/material.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';

class NewMoneyTransactionPage extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text("Nuova transazione"),
      ),
      body: _NewTransactionFormWidget(),
    );
  } 
}

class _NewTransactionFormWidget extends StatefulWidget{
  _NewTransactionFormWidget({Key key}) : super(key:key);
  
  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<_NewTransactionFormWidget>{
  final _formKey = GlobalKey<FormState>();
  MoneyTransactionType transactionType;
  String transactionText;
  double transactionCost;
  
  Widget build(BuildContext context){
    return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Tipologia transazione",
                    textAlign: TextAlign.left, 
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 8,right: 8),
                  title: Text("Movimento In entrata"),
                  leading: Radio(
                    groupValue: transactionType,
                    value: MoneyTransactionType.received,
                    onChanged: (MoneyTransactionType value){
                      setState((){
                        transactionType= value;
                      });
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 8,right: 8),
                  title: Text("Movimento In uscita"),
                  leading: Radio(
                    groupValue: transactionType,
                    value: MoneyTransactionType.spent,
                    onChanged: (MoneyTransactionType value){
                     setState((){
                        transactionType = value;
                      });
                    },
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.title),
                        hintText: 'Descrizione della spesa/acquisto fatto',
                        labelText: 'Causale *',
                      ),
                      onSaved: (String _value){
                        transactionText = _value;
                      },
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.euro_symbol),
                        hintText: 'Quanto hai ricevuto speso?',
                        labelText: 'Soldi *',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String value){
                        return RegExp(r'^\d*\.?\d*$').hasMatch(value.replaceAll(',', '.')) ? null :
                          "Valore non valido";
                      },
                      onSaved: (String _value){
                        _value = _value.replaceAll(',', '.');
                        transactionCost = double.tryParse(_value) ?? 0;
                      },
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Salva"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save(); // Save our form now.

                        var newTransaction = MoneyTransaction(
                          cost: transactionCost,
                          text: transactionText,
                          transactionType: transactionType ?? MoneyTransactionType.received,
                          date:DateTime.now(),
                        );

                        Future.wait( [addMoneyTransaction(newTransaction)]);
                        Navigator.pop(context, newTransaction);
                      }
                    },
                  ),
                )
              ],
            ),
          );
  }
}