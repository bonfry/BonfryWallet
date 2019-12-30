import 'package:bonfry_wallet/data/enums/money_transaction_type.dart';
import 'package:bonfry_wallet/data/models/money_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget{

  final MoneyTransaction transaction;

  TransactionListItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    String transactionSimbol = transaction.transactionType == MoneyTransactionType.received ? "+":"-";
    return  Column(
        children: <Widget>[
          Row(
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
                        textAlign : TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(width: 12, color:transaction.moneyBudget.color))
                  ), 
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: 10,top: 15,right: 10, bottom: 15),
                child: Column(
                  children: <Widget>[
                    Text("${new DateFormat('d MMM y').format(transaction.date).toUpperCase()}"),
                    Text(
                      "$transactionSimbol ${transaction.cost.toStringAsFixed(2)} €",
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
          Divider(color: Colors.grey,height: 2),
        ],
      );
  }
}