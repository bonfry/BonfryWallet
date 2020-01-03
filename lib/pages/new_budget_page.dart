import 'package:bonfry_wallet/data/models/money_budget.dart';
import 'package:bonfry_wallet/widgets/bottom_sheet_from_git.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';

class NewBudgetBottomSheetContent extends StatefulWidget{

  @override
  NewBudgetBottomSheetContentState createState() => NewBudgetBottomSheetContentState();
}

class NewBudgetBottomSheetContentState extends State<NewBudgetBottomSheetContent>{
  String budgetText;
  Color budgetColor;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Container(
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
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Nome del budget",
                  labelText: "Nome"
                ),
                onSaved: (String text){
                  budgetText = text;
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                Color color = await showColorDialog(context);

                if(color != null){
                  setState(() {
                    budgetColor = color;
                  });
                }
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
                        border: budgetColor == null ? Border.all(): null,
                        shape: BoxShape.circle,
                        color: budgetColor
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
                    onPressed: () async{
                      _formKey.currentState.save();

                      MoneyBudget newBudget = MoneyBudget(
                        title: budgetText,
                        color: budgetColor
                      );

                      await addMoneyBudget(newBudget);

                      Navigator.pop(context,newBudget);
                    },
                  ),
                  FlatButton(
                    child:Text("Annulla"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<MoneyBudget> showNewBudgetBottomSheet(context){
   return showModalBottomSheetApp<MoneyBudget>(
      context: context,
      builder: (context) =>
        NewBudgetBottomSheetContent()
    );
}



Future<Color> showColorDialog(BuildContext context) async {
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    currentColor = color;
  }

  return await showDialog<Color>(
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
            onPressed: (){
              Navigator.pop(context,currentColor);
            },
          ),
          FlatButton(
            child: Text("Annulla"),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
    }
  );
}