import 'package:bonfry_wallet/widgets/bottom_sheet_from_git.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';


class NewBudgetBottomSheetContent extends StatefulWidget{

  @override
  NewBudgetBottomSheetContentState createState() => NewBudgetBottomSheetContentState();
}

class NewBudgetBottomSheetContentState extends State<NewBudgetBottomSheetContent>{
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Aggiungi budget",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(),
          ),
          GestureDetector(
            onTap: (){
              showColorDialog(context);
            },
            child:Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom:5 ),
                          child: Text(
                            "Colore selezionato",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17
                            )
                          ),
                        ),
                        Text("Seleziona colore")
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      shape: BoxShape.circle
                    ),
                  )
                ],
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child:Text("Salva"),
                  onPressed: (){},
                ),
                FlatButton(
                  child:Text("Annulla"),
                  onPressed: (){},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void showNewBudgetBottomSheet(context){
  showModalBottomSheetApp<void>(
      context: context,
      builder: (context) => 
        NewBudgetBottomSheetContent()
    );
}



Future<void> showColorDialog(BuildContext context) async {
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
  }

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleziona colore'),
        content: SingleChildScrollView(
           child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: changeColor,
            ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Salva"),
            onPressed: (){},
          ),
          FlatButton(
            child: Text("Annulla"),
            onPressed: (){},
          )
        ],
      );
    }
  );
}