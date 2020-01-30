import 'package:bonfry_wallet/pages/splash_page.dart';
import 'package:flutter/material.dart';

void main(){
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bonfry Wallet',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SplashPage(),
    );
  }
}

