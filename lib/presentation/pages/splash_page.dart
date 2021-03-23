import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Center(
                child: Image.asset(
                  'images/splash_logo.png',
                  height: 200,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'images/splash_name_logo.png',
                  height: 50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
