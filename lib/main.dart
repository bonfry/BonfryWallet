import 'package:bonfry_wallet/app.dart';
import 'package:bonfry_wallet/data/dataproviders/database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await DatabaseManager().database;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: db),
      ],
      child: App(),
    ),
  );
}
