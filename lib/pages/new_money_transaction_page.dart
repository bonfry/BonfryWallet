import 'package:bonfry_wallet/data/models/money_budget.dart';
import 'package:flutter/material.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';
import 'new_budget_page.dart';

class NewMoneyTransactionPage extends StatelessWidget{
  final List<MoneyBudget> moneyBudgets;

  NewMoneyTransactionPage(this.moneyBudgets);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text("Nuova transazione"),
      ),
      body: _NewTransactionFormWidget(moneyBudgets:moneyBudgets),
    );
  } 
}

class _NewTransactionFormWidget extends StatefulWidget{
  final List<MoneyBudget> moneyBudgets;

  _NewTransactionFormWidget({Key key, this.moneyBudgets}) : super(key:key);
  
  @override
  _NewTransactionFormState createState() => _NewTransactionFormState(moneyBudgets: moneyBudgets);
}

class _NewTransactionFormState extends State<_NewTransactionFormWidget>{
  final _formKey = GlobalKey<FormState>();
  MoneyTransactionType transactionType;
  String transactionText;
  double transactionCost;
  MoneyBudget moneyBudget;
  List<MoneyBudget> moneyBudgets= [];

  String textFormError = "";

  _NewTransactionFormState({this.moneyBudgets});

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Visibility(
            visible: textFormError.length > 0,
            child:Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child:Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Errore:",
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.w700, 
                            fontSize: 17
                          ),
                        )
                      ),
                      Text(textFormError,style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                color: Colors.red[600],
              ),
            ),
          ),
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
                  transactionType = value;
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
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DropdownButtonFormField<MoneyBudget>(
                  value: moneyBudget,
                  decoration: InputDecoration(
                    labelText: "Budget",
                    icon: Icon(Icons.monetization_on),
                    hintText: "Seleziona un budget"
                  ),
                  isExpanded: true,
                  items: moneyBudgets.map((MoneyBudget budget) {
                    return new DropdownMenuItem<MoneyBudget>(
                      value: budget,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              border: budget.color == null ? Border.all(): null,
                              shape: BoxShape.circle,
                              color: budget.color
                            ),
                            margin: EdgeInsets.only(right: 8),
                          ),
                          Text(budget.title),
                        ],
                      )
                    );
                  }).toList(),
                  onChanged: (budget) {
                    setState((){
                      moneyBudget = budget;
                    });
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top:4,left: 40),
                    child: Text(
                      "Aggiungi Budget",
                      style: TextStyle(
                        color: Colors.indigo[800]
                      ),
                    ),
                  ),
                  onTap: (){
                    showNewBudgetBottomSheet(context);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Salva"),
              onPressed: () async{
                if ( moneyBudget != null && _formKey.currentState.validate()) {
                  
                  setState(() {
                    textFormError = "";
                  });

                  _formKey.currentState.save(); // Save our form now.

                  var newTransaction = MoneyTransaction(
                    cost: transactionCost,
                    text: transactionText,
                    transactionType: transactionType ?? MoneyTransactionType.received,
                    moneyBudgetId: moneyBudget.id,
                    date:DateTime.now(),
                  );

                  await addMoneyTransaction(newTransaction);

                  newTransaction.moneyBudget = moneyBudget;
                  Navigator.pop(context, newTransaction);
                }else if(moneyBudget == null){
                  setState(() {
                    textFormError = "Budget non inserito";
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
