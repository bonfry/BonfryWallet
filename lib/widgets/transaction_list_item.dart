import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';
import 'package:bonfry_wallet/helpers/amount_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget{

  final MoneyTransaction transaction;

  TransactionListItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    String transactionSimbol = transaction.transactionType == MoneyTransactionType.received ? "+":"-";
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
            children: <Widget>[
              Expanded(
                child:Container(
                  margin: EdgeInsets.only(left:10),
                  padding:EdgeInsets.only(left:4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(transaction.moneyBudget.title.toUpperCase()),
                      Text(
                        transaction.text,
                        textAlign : TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(width: 9, color:transaction.moneyBudget.color))
                  ), 
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Text("${new DateFormat('d MMM y').format(transaction.date).toUpperCase()}"),
                    Text(
                      "$transactionSimbol ${getAmountStringFormatted(transaction.amount)}",
                      style: TextStyle(
                        fontWeight:FontWeight.w600,
                        fontSize: 22,
                        color: transaction.transactionType == MoneyTransactionType.received ?
                          Colors.green[800] : Colors.red[800] 
                      )
                    )
                  ],
                )
              ),
            ],
          ),
      );
  }
}