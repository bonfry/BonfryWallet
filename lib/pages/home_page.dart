import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/model/model.dart';
import 'package:bonfry_wallet/helpers/ColorPalette.dart';
import 'package:bonfry_wallet/helpers/amount_helpers.dart';
import 'package:bonfry_wallet/widgets/page_bar.dart';
import 'package:bonfry_wallet/widgets/page-title.dart';
import 'package:bonfry_wallet/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'money_transaction_edit_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageData {
  final List<MoneyBudget> budgets;
  final List<MoneyTransaction> transactions;

  _HomePageData(this.budgets, this.transactions);
}

class _HomePageState extends State<HomePage> {
  List<MoneyTransaction> moneyTransactions;
  List<MoneyBudget> moneyBudget;

  String getTotalAmount() {
    double totalAmount = 0;

    for (var t in moneyTransactions) {
      totalAmount += t.transactionType == MoneyTransactionType.received.index
          ? t.import
          : (-1) * t.import;
    }

    return getAmountStringFormatted(totalAmount);
  }

  Future<_HomePageData> importTransactions() async {
    return _HomePageData(await MoneyBudget().select().toList(),
        await MoneyTransaction().select().toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_HomePageData>(
        future: importTransactions(),
        initialData: _HomePageData([], []),
        builder: (context, snapshot) {
          moneyTransactions = snapshot.data.transactions;
          moneyBudget = snapshot.data.budgets;

          return Scaffold(
            appBar: BWalletAppBar(
                context: context,
                leading: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Image(
                      image: AssetImage('images/home_icon.png'),
                      fit: BoxFit.fill),
                ),
                label: 'my wallet'),
            body: Container(
              child: ListView(
                children: <Widget>[
                  TitleWidget("Budget Attuale"),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                          "${getTotalAmount()}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 45),
                        )),
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
              backgroundColor: BonfryWalletColorPalette.blue1,
              onPressed: () async {
                List<MoneyBudget> budgetListToSend =
                    await MoneyBudget().select().toList();

                var response = await goToMoneyTransactionEdit(
                    context: context, budgets: budgetListToSend);

                if (response.responseType ==
                    MoneyTransactionEditResponseType.created) {
                  setState(() {
                    moneyTransactions.add(response.data);
                  });
                }
              },
            ),
          );
        });
  }

  List<Widget> buildListTiles(BuildContext context) {
    return moneyTransactions.map((t) {
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
                          await t.delete(true);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("CANCELLA")),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("ANNULLA"),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) async {
            setState(() {
              moneyTransactions.remove(t);
            });

            /*
            * globalKey.currentState.showSnackBar(SnackBar(
              content: Text("Elemento eliminato"),
            ));*/
          },
          direction: DismissDirection.endToStart,
          background: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red[900],
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 35,
              )),
          child: GestureDetector(
            onTap: () async {
              List<MoneyBudget> budgetListToSend =
                  await MoneyBudget().select().toList();

              var response = await goToMoneyTransactionEdit(
                  context: context, budgets: budgetListToSend, transaction: t);

              if (response.responseType ==
                  MoneyTransactionEditResponseType.updated) {
                setState(() {
                  t = response.data;
                });
              } else if (response.responseType ==
                  MoneyTransactionEditResponseType.removed) {
                setState(() {
                  moneyTransactions.remove(t);
                });
              }
            },
            child: TransactionListItem(t),
          ));
    }).toList();
  }
}
