import 'package:bonfry_wallet/data/model/model.dart';
import 'package:bonfry_wallet/helpers/ColorPalette.dart';
import 'package:bonfry_wallet/widgets/bottom_sheet_from_git.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BudgetEditor extends StatefulWidget {
  final MoneyBudget currentBudget;

  BudgetEditor({this.currentBudget});

  @override
  BudgetEditorState createState() =>
      BudgetEditorState(currentBudget: currentBudget);
}

class BudgetEditorState extends State<BudgetEditor> {
  MoneyBudget currentBudget;

  BudgetEditorState({this.currentBudget}) {
    if (currentBudget == null) {
      currentBudget = MoneyBudget();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context,
                        BudgetEditorResponse(BudgetEditorResponseType.aborted));
                  },
                ),
                Expanded(
                    child: Text(
                  currentBudget != null ? "Modifica budget" : "Aggiungi budget",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
                Container(
                  padding:
                      EdgeInsets.only(right: currentBudget.id == null ? 12 : 0),
                  child: RaisedButton(
                    child: Text("Salva"),
                    color: BonfryWalletColorPalette.blue1,
                    textColor: Colors.white,
                    onPressed: () async {
                      _formKey.currentState.save();

                      await currentBudget.save();

                      BudgetEditorResponse response;

                      if (currentBudget.id == null) {
                        response = BudgetEditorResponse(
                            BudgetEditorResponseType.created,
                            result: currentBudget);
                      } else {
                        response = BudgetEditorResponse(
                            BudgetEditorResponseType.updated,
                            result: currentBudget);
                      }

                      Navigator.pop(context, response);
                    },
                  ),
                ),
                Visibility(
                  visible: currentBudget.id != null,
                  child: PopupMenuButton<int>(
                    onSelected: (value) async {
                      switch (value) {
                        case 0:
                          await this.currentBudget.delete();
                          return Navigator.pop(
                              context,
                              BudgetEditorResponse(
                                  BudgetEditorResponseType.removed));
                      }

                      return Navigator.pop(
                          context,
                          BudgetEditorResponse(
                              BudgetEditorResponseType.aborted));
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Elimina budget"),
                        ),
                      ];
                    },
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: TextFormField(
                initialValue: currentBudget.title,
                decoration: InputDecoration(
                    hintText: "Nome del budget", labelText: "Nome"),
                onSaved: (String text) {
                  currentBudget.title = text;
                },
              ),
            ),
            GestureDetector(
                onTap: () async {
                  Color color = await showColorDialog(context);

                  if (color != null) {
                    setState(() {
                      currentBudget.color = color.value;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 48),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text("Colore selezionato",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17)),
                            ),
                            Text("Seleziona colore")
                          ],
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            border: currentBudget.color == null
                                ? Border.all()
                                : null,
                            shape: BoxShape.circle,
                            color: Color(currentBudget.color)),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

Future<BudgetEditorResponse> showBudgetEditor(context,
    {MoneyBudget budget}) async {
  var modalResponse = await showModalBottomSheetApp<BudgetEditorResponse>(
      context: context,
      builder: (context) => BudgetEditor(currentBudget: budget));

  return modalResponse ??
      BudgetEditorResponse(BudgetEditorResponseType.aborted);
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
              onPressed: () {
                Navigator.pop(context, currentColor);
              },
            ),
          ],
        );
      });
}

enum BudgetEditorResponseType { aborted, created, updated, removed }

class BudgetEditorResponse {
  final BudgetEditorResponseType resultType;
  final MoneyBudget result;

  BudgetEditorResponse(this.resultType, {this.result});
}
