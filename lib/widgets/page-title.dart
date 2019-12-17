import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget{
  final String title;

  const TitleWidget(this.title);
  
  static const TextStyle titleStyle = 
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey);
  
  Widget build(BuildContext context){
    return Row(children: <Widget>[
        Container(
          child: Text(this.title,style: titleStyle),
          padding: EdgeInsets.all(32),
        )
      ],
    );
  }
}