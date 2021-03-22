import 'dart:convert';

import 'package:equatable/equatable.dart';

class MoneyBudget extends Equatable {
  final int id;
  final String color;
  final String title;
  MoneyBudget({
    required this.id,
    required this.color,
    required this.title,
  });

  MoneyBudget copyWith({
    int? id,
    String? color,
    String? title,
  }) {
    return MoneyBudget(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'title': title,
    };
  }

  factory MoneyBudget.fromMap(Map<String, dynamic> map) {
    return MoneyBudget(
      id: map['id'],
      color: map['color'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyBudget.fromJson(String source) =>
      MoneyBudget.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, color, title];
}
