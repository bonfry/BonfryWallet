import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableMoneyBudget = SqfEntityTable(
    tableName: 'money_budget',
    primaryKeyName: 'id',
    modelName: 'MoneyBudget',
    useSoftDeleting: true,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('title', DbType.text, defaultValue: ''),
      SqfEntityField('color', DbType.integer, defaultValue: 0x00000000)
    ]);

const tableMoneyTransaction = SqfEntityTable(
    tableName: 'money_transactions',
    primaryKeyName: 'id',
    modelName: 'MoneyTransaction',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('title', DbType.text),
      SqfEntityField('import', DbType.real),
      SqfEntityField('date', DbType.datetime),
      SqfEntityField('transactionType', DbType.integer),
      SqfEntityFieldRelationship(
        fieldName: 'moneyBudgetId',
        parentTable: tableMoneyBudget,
        deleteRule: DeleteRule.CASCADE,
      ),
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(appDbModel)
const appDbModel = SqfEntityModel(
    modelName: 'BonfryWalletModel', // optional
    databaseTables: [tableMoneyTransaction, tableMoneyBudget],
    sequences: [seqIdentity],
    databaseName: 'walletDB.db');
