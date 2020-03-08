import 'package:bonfry_wallet/data/model/model.dart';
import 'package:bonfry_wallet/widgets/budget_editor.dart';
import 'package:bonfry_wallet/widgets/page_bar.dart';
import 'package:flutter/material.dart';
import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';

enum MoneyTransactionEditResponseType { aborted, created, updated, removed }

class MoneyTransactionEditResponse {
  MoneyTransactionEditResponseType responseType =
      MoneyTransactionEditResponseType.aborted;
  final MoneyTransaction data;

  MoneyTransactionEditResponse({this.responseType, this.data});
}

class MoneyTransactionEditPage extends StatelessWidget {
  final List<MoneyBudget> moneyBudgets;
  final MoneyTransaction transaction;

  MoneyTransactionEditPage(this.moneyBudgets, {this.transaction});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BWalletAppBar(
        context: context,
        label:
            transaction == null ? "Nuova transazione" : "Modifica transazione",
      ),
      /*
      *
      *
      AppBar(
        backgroundColor: Colors.indigo[700],
        actions: <Widget>[
          Visibility(
            visible: transaction != null,
            child: PopupMenuButton<int>(
              onSelected: (value) async {
                switch (value) {
                  case 0:
                    await MoneyTransaction()
                        .getById(this.transaction.id)
                        .then((tx) => tx.delete());
                    return Navigator.pop(
                        context,
                        MoneyTransactionEditResponse(
                            responseType:
                                MoneyTransactionEditResponseType.removed));
                }

                return Navigator.pop(context,
                    BudgetEditorResponse(BudgetEditorResponseType.aborted));
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Elimina budget"),
                  ),
                ];
              },
            ),
          )
        ],
      ),*/
      body: _TransactionEditForm(
        moneyBudgets: moneyBudgets,
        transaction: transaction,
      ),
    );
  }
}

class _TransactionEditForm extends StatefulWidget {
  final List<MoneyBudget> moneyBudgets;
  final MoneyTransaction transaction;

  _TransactionEditForm({Key key, this.moneyBudgets, this.transaction})
      : super(key: key);

  @override
  _TransactionEditFormState createState() => _TransactionEditFormState(
      moneyBudgets: moneyBudgets, transaction: transaction);
}

class _TransactionEditFormState extends State<_TransactionEditForm> {
  final _formKey = GlobalKey<FormState>();
  List<MoneyBudget> moneyBudgets;
  MoneyTransaction transaction;

  String textFormError = "";

  _TransactionEditFormState({this.moneyBudgets, this.transaction}) {
    if (this.transaction == null) {
      this.transaction = new MoneyTransaction();
    }
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Visibility(
            visible: textFormError.length > 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Container(
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
                                fontSize: 17),
                          )),
                      Text(textFormError,
                          style: TextStyle(color: Colors.white)),
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
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 8, right: 8),
            title: Text("Movimento In entrata"),
            leading: Radio(
              groupValue: transaction.transactionType,
              value: MoneyTransactionType.received.index,
              onChanged: (int value) {
                setState(() {
                  transaction.transactionType = value;
                });
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 8, right: 8),
            title: Text("Movimento In uscita"),
            leading: Radio(
              groupValue: transaction.transactionType,
              value: MoneyTransactionType.spent.index,
              onChanged: (int value) {
                setState(() {
                  transaction.transactionType = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: transaction.title,
              decoration: const InputDecoration(
                icon: Icon(Icons.title),
                hintText: 'Descrizione della spesa/acquisto fatto',
                labelText: 'Causale *',
              ),
              onSaved: (String _value) {
                transaction.title = _value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: transaction.import != null
                  ? transaction.import.toString()
                  : null,
              decoration: const InputDecoration(
                icon: Icon(Icons.euro_symbol),
                hintText: 'Quanto hai ricevuto speso?',
                labelText: 'Importo *',
              ),
              keyboardType: TextInputType.number,
              validator: (String value) {
                return RegExp(r'^\d*\.?\d*$')
                        .hasMatch(value.replaceAll(',', '.'))
                    ? null
                    : "Valore non valido";
              },
              onSaved: (String _value) {
                _value = _value.replaceAll(',', '.');
                transaction.import = double.tryParse(_value) ?? 0;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Listener(
                  onPointerUp: (_) => FocusScope.of(context).unfocus(),
                  onPointerDown: (_) => FocusScope.of(context).unfocus(),
                  child: DropdownButtonFormField<int>(
                    value: transaction.plMoneyBudget != null
                        ? transaction.plMoneyBudget.id
                        : null,
                    decoration: InputDecoration(
                        labelText: "Budget",
                        icon: Icon(Icons.account_balance_wallet),
                        hintText: "Seleziona un budget"),
                    isExpanded: true,
                    items: moneyBudgets.map((MoneyBudget budget) {
                      return new DropdownMenuItem<int>(
                          value: budget.id,
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    border: budget.color == null
                                        ? Border.all()
                                        : null,
                                    shape: BoxShape.circle,
                                    color: Color(budget.color)),
                                margin: EdgeInsets.only(right: 8),
                              ),
                              Text(budget.title),
                            ],
                          ));
                    }).toList(),
                    onChanged: (budgetId) {
                      setState(() {
                        transaction.moneyBudgetId = budgetId;
                        transaction.plMoneyBudget =
                            moneyBudgets.firstWhere((b) => b.id == budgetId);
                      });
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 4, left: 40),
                    child: Text(
                      "Aggiungi Budget",
                      style: TextStyle(color: Colors.indigo[800]),
                    ),
                  ),
                  onTap: () async {
                    var budgetEditorResponse = await showBudgetEditor(context);

                    if (budgetEditorResponse.resultType ==
                        BudgetEditorResponseType.created) {
                      setState(() {
                        moneyBudgets.add(budgetEditorResponse.result);
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Salva"),
              onPressed: () async {
                if (transaction.plMoneyBudget != null &&
                    _formKey.currentState.validate()) {
                  setState(() {
                    textFormError = "";
                  });

                  _formKey.currentState.save(); // Save our form now.

                  transaction.date = DateTime.now();

                  MoneyTransactionEditResponseType responseType;

                  if (transaction.id != null) {
                    responseType = MoneyTransactionEditResponseType.updated;
                  } else {
                    responseType = MoneyTransactionEditResponseType.created;
                  }

                  var result = await transaction.save();
                  print(result);

                  Navigator.pop(
                      context,
                      MoneyTransactionEditResponse(
                          responseType: responseType, data: transaction));
                }

                if (textFormError == null &&
                    transaction.transactionType == null) {
                  setState(() {
                    textFormError =
                        "Non hai inserito la tipologia di transazione";
                  });
                }

                if (textFormError == null &&
                    transaction.plMoneyBudget == null) {
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

Future<MoneyTransactionEditResponse> goToMoneyTransactionEdit(
    {BuildContext context,
    List<MoneyBudget> budgets,
    MoneyTransaction transaction}) {
  return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  MoneyTransactionEditPage(budgets, transaction: transaction)))
      .then((response) =>
          response ??
          MoneyTransactionEditResponse(
              responseType: MoneyTransactionEditResponseType.aborted));
}
