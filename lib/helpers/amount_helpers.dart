import 'dart:math';

String getAmountStringFormatted(double money){
    String extraAmountUnit = "";

    double moneyToPrint;

    if(money.abs() >= pow(10, 6)){
      moneyToPrint = (money / pow(10, 6).toDouble());
      extraAmountUnit = "M";
    } else if(money.abs() >= pow(10, 3)){
      moneyToPrint = (money/ pow(10, 3).toDouble()) ;
      extraAmountUnit = "K";
    }else{
      moneyToPrint = money;
    }

    var moneyStringParts = moneyToPrint.toString().split('.');

    String moneyIntegerString = moneyStringParts[0];
    String moneyDecimalString = moneyStringParts[1];

    moneyDecimalString = moneyDecimalString.length <= 2 ? moneyDecimalString : moneyDecimalString.substring(0,2);

    return" $moneyIntegerString,$moneyDecimalString $extraAmountUnit€";
  }