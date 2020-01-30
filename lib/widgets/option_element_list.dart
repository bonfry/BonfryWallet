import 'package:flutter/material.dart';

typedef VoidCallbackWithContext = void Function(BuildContext);
typedef ChildTapCallback = void Function(BuildContext context,int index);

class OptionElement{
  final VoidCallbackWithContext callback;
  final String text;
  final String subText;
  IconData icon;

  OptionElement(this.text,{this.callback, this.icon, this.subText,});
}

class OptionElementList extends StatelessWidget{

  final List<OptionElement> children;
  final ChildTapCallback onChildTap;

  const OptionElementList({Key key, this.children, this.onChildTap}) : super(key: key);

  Widget build(BuildContext context){
    return ListView.builder(
        itemCount: children != null ? children.length : 0,
        itemBuilder: (context, index){
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            leading: children[index].icon != null? Container(
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: Colors.indigo[700],
                  shape: BoxShape.circle
              ),
              child: Icon(children[index].icon,color: Colors.white,),
            ): SizedBox(
              height: 24,
              width: 24,
            ),
            title: Text(children[index].text,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
            subtitle:  Text(children[index].subText),
            onTap: onChildTap != null || children[index].callback!= null ? (){
              children[index].callback(context);

              if(onChildTap != null){
                onChildTap(context,index);
              }
            }: null,
          );
    });
  }
}