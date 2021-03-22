import 'dart:convert';

import 'package:bonfry_wallet/data.dart';
import 'package:equatable/equatable.dart';

import 'package:bonfry_wallet/data/models/money_budget.dart';

class MoneyTransactionsSign {
  static const POSITIVE = 1;
  static const NEGATIVE = -1;
}

class MoneyTransaction extends Equatable {
  final int id;
  final String title;
  final double import;
  final DateTime date;
  final int transactionSign;
  final MoneyBudget budget;

  MoneyTransaction({
    required this.id,
    required this.title,
    required this.import,
    required this.date,
    required this.transactionSign,
    required this.budget,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      import,
      date,
      transactionSign,
      budget,
    ];
  }

  MoneyTransaction copyWith({
    int? id,
    String? title,
    double? import,
    DateTime? date,
    int? transactionSign,
    MoneyBudget? budget,
  }) {
    return MoneyTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      import: import ?? this.import,
      date: date ?? this.date,
      transactionSign: transactionSign ?? this.transactionSign,
      budget: budget ?? this.budget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'import': import,
      'date': date.millisecondsSinceEpoch,
      'transactionSign': transactionSign,
      'budget': budget.id,
    };
  }

  factory MoneyTransaction.fromMap(Map<String, dynamic> map) {
    return MoneyTransaction(
      id: map['id'],
      title: map['title'],
      import: map['import'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      transactionSign: map['transactionSign'] ??
          _convertTransactionTypeToSign(map['transactionType']),
      budget: MoneyBudget.fromMap(map['budget']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyTransaction.fromJson(String source) =>
      MoneyTransaction.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}

int _convertTransactionTypeToSign(int transactionTypeValue) {
  return transactionTypeValue == MoneyTransactionType.received.index
      ? MoneyTransactionsSign.POSITIVE
      : MoneyTransactionsSign.POSITIVE;
}
