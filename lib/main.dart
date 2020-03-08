import 'package:bonfry_wallet/helpers/ColorPalette.dart';
import 'package:bonfry_wallet/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setTransparentBar();
  }

  void setTransparentBar() {
    bool isDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;

    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor:
              Color.fromRGBO(48, 48, 48, 1), // navigation bar color
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness:
              Brightness.light // status bar icons' color
          ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor:
              Color.fromRGBO(250, 250, 250, 1), // navigation bar color
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness:
              Brightness.dark // status bar icons' color
          // status bar icons' color
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    setTransparentBar();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bonfry Wallet',
      theme: ThemeData(primaryColor: BonfryWalletColorPalette.blue1),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: BonfryWalletColorPalette.blue1,
        accentColor: BonfryWalletColorPalette.blue1,
      ),
      home: SplashPage(),
    );
  }
}
