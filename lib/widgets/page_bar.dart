import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BWalletAppBar extends AppBar {
  final String label;
  final List<Widget> actions;
  final Widget leading;
  final IconData leadingIcon;

  static final standardColor = Color.fromRGBO(126, 126, 126, 1);
  static final standardBackgroundColor = Color.fromRGBO(250, 250, 250, 1);
  static final standardDarkBackgroundColor = Color.fromRGBO(48, 48, 48, 1);

  BWalletAppBar(
      {Key key,
      BuildContext context,
      this.leading,
      this.label,
      this.actions,
      this.leadingIcon})
      : super(
            brightness: MediaQuery.of(context).platformBrightness,
            key: key,
            elevation: 0,
            iconTheme: _getIconThemeData(context),
            leading: leading,
            backgroundColor: _getBackgroundColor(context),
            title: _getTitleText(context, label),
            actions: actions);

  static IconThemeData _getIconThemeData(BuildContext context) {
    var platformBrightness = MediaQuery.of(context).platformBrightness;

    Color iconColor =
        platformBrightness == Brightness.light ? standardColor : Colors.white;

    return IconThemeData(color: iconColor);
  }

  static Color _getBackgroundColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? standardDarkBackgroundColor
        : standardBackgroundColor;
  }

  static Text _getTitleText(BuildContext context, String label) {
    var platformBrightness = MediaQuery.of(context).platformBrightness;
    Color textColor =
        platformBrightness == Brightness.light ? standardColor : Colors.white;

    return Text(
      label.toUpperCase(),
      style: TextStyle(color: textColor),
    );
  }
}
