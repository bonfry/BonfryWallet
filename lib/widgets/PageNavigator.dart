import 'package:bonfry_wallet/helpers/ColorPalette.dart';
import 'package:bonfry_wallet/pages/home_page.dart';
import 'package:bonfry_wallet/pages/settings_budget_page.dart';
import 'package:bonfry_wallet/pages/settings_main_page.dart';
import 'package:bonfry_wallet/widgets/budget_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class PageNavigator extends StatefulWidget {
  PageNavigator({Key key}) : super(key: key);

  @override
  PageNavigatorState createState() => PageNavigatorState();
}

class PageNavigatorState extends State<PageNavigator> {
  int _currentPageIndex = 0;
  static List<Widget> _pages = <Widget>[
    HomePage(),
    BudgetSettingsPage(),
    HomePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var navBarIconColor =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? Color.fromRGBO(126, 126, 126, 1)
            : Colors.white;
    return Scaffold(
      body: _pages.elementAt(_currentPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: navBarIconColor,
        elevation: 4,
        currentIndex: _currentPageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(
              MaterialCommunityIcons.home,
            ),
          ),
          BottomNavigationBarItem(
            title: Text("Budget"),
            icon: Icon(
              MaterialCommunityIcons.bank,
            ),
          ),
          BottomNavigationBarItem(
            title: Text("Risparmi"),
            icon: Icon(MaterialCommunityIcons.piggy_bank),
          ),
          BottomNavigationBarItem(
            title: Text("Impostazioni"),
            icon: Icon(MaterialCommunityIcons.settings),
          ),
        ],
        selectedItemColor: BonfryWalletColorPalette.blue1,
        onTap: _onItemTapped,
      ),
    );
  }
}
