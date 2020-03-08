import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/model/model.dart';
import 'package:bonfry_wallet/helpers/amount_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatefulWidget {
  final MoneyTransaction transaction;
  TransactionListItem(this.transaction);

  @override
  TransactionListItemState createState() =>
      TransactionListItemState(transaction);
}

class TransactionListItemState extends State<TransactionListItem> {
  final MoneyTransaction transaction;
  MoneyBudget budget;

  TransactionListItemState(this.transaction) {
    if (transaction.title == null) {
      transaction.title = "(nessun titolo inserito)";
    }
  }

  String getTransactionSymbol() {
    return transaction.transactionType == MoneyTransactionType.received.index
        ? "+"
        : "-";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MoneyBudget>(
      future: transaction.getMoneyBudget(),
      initialData: MoneyBudget(title: '', color: Colors.transparent.value),
      builder: (context, snap) {
        budget = snap.data;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(budget.title.toUpperCase()),
                    Text(
                      transaction.title,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                decoration: budget.color != null
                    ? BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                width: 9, color: Color(budget.color))))
                    : null,
              )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                          "${new DateFormat('d MMM y').format(transaction.date).toUpperCase()}"),
                      Text(
                          "${getTransactionSymbol()} ${getAmountStringFormatted(transaction.import)}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: transaction.transactionType ==
                                      MoneyTransactionType.received.index
                                  ? Colors.green[800]
                                  : Colors.red[800]))
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}
