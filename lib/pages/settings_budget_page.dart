import 'package:bonfry_wallet/data/models/money_budget.dart';
import 'package:bonfry_wallet/widgets/budget_editor.dart';
import 'package:flutter/material.dart';


typedef OnRemoveElement = void Function(DismissDirection,int); 


class BudgetSettingsPage extends StatefulWidget{

  @override
  _BudgetSettigsPageState createState() => _BudgetSettigsPageState();
}

class _BudgetSettigsPageState extends State<BudgetSettingsPage>{

  List<MoneyBudget> moneyBudgets;

  @override
  Widget build(BuildContext context){
    return FutureBuilder<void>(
      future: getMoneyBudgetList().then((list){
        this.moneyBudgets = list;
      }),
      builder: (context,snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text("Budget inseriti"),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: ()async{
              var budgetEditorResponse = await showBudgetEditor(context);

              setState(() {
                moneyBudgets.add(budgetEditorResponse.result);
              });
            },
          ),
          body: snapshot.connectionState == ConnectionState.done ? buildBudgetList(moneyBudgets, onDismiss: (direction,i) async{
            setState(() {
              moneyBudgets.removeAt(i);
            });
          }) : buildWaitingLoading(),
        );
      },
    );
  }



Widget buildWaitingLoading(){
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget buildBudgetList(List<MoneyBudget> moneyBudgets, {OnRemoveElement onDismiss}){
  return ListView.builder(
    itemCount: moneyBudgets.length,
    itemBuilder: (context,index){
      return Dismissible(
        key: Key(index.toString()),
        confirmDismiss: (direction) async{
          await removeMoneyBudget(moneyBudgets[index].id);
          return true;
        },
        onDismissed: (direction){
          setState(() {
            moneyBudgets.removeAt(index);
          });
        },
        child:ListTile(
          leading: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              border: moneyBudgets[index].color == null ? Border.all(): null,
              shape: BoxShape.circle,
              color: moneyBudgets[index].color
            ),
            margin: EdgeInsets.only(right: 8),
          ),
          title:  Text(moneyBudgets[index].title),
          onTap: () async {
            var budgetEditorResponse = await showBudgetEditor(context, budget: moneyBudgets[index]);

            switch(budgetEditorResponse.resultType){
              case BudgetEditorResponseType.updated:
                setState(() {
                  moneyBudgets[index] = budgetEditorResponse.result;
                });
                break;
              case BudgetEditorResponseType.removed:
                setState(() {
                  moneyBudgets.removeAt(index);
                });
                break;
              default: break;
            }
          },
        ),
      );
    },
  );
}

}
