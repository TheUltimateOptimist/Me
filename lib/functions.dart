// this file contains small functions that are often needed

String currentDateString({bool yesterday = false}) {
  DateTime now = DateTime.now();
  if (yesterday) {
    now = now.subtract(Duration(days: 1));
  }
  return now.year.toString() +
        "-" +
        formatZero(now.month) +
        "-" +
        formatZero(now.day);
}

String formatZero(int number) {
  if (number < 10) {
    return "0" + number.toString();
  } else
    return number.toString();
}

String qotate(String s){
return "'" + s + "'";
}

///takes a two dimensional list of values and qotates those that are of type string for entry in a database
///
///others are converted to a string
///
///returns same reworked list
List<List<String>> prepareValuesForInsertion(List<List<dynamic>> values){
    List<List<String>> result = List.empty(growable: true);
    for(var row in values){
      List<String> newList = List.empty(growable: true);
      for(var value in row){
        if(value.runtimeType == String){
          newList.add(qotate(value));
        }
        else newList.add(value.toString());
      }
      result.add(newList);
    }
    return result;
}

///returns a list of lists with string values into a string so it can be added to an sql insert Statement
///
///example:
///
///```dart
///String s = mapValuesForInsertion([["Odillia", "verheiratet"], ["Lisa", "single"]]);
///
///s = VALUES ()
///```
String mapValuesForInsertion(List<List<String>> list){
  String result = "VALUES ";
  int i = 0;
  for(var row in list){
    if(i != list.length -1){
    result = result + "(" + row.join(", ") + "), ";}
    else result = result + "(" + row.join(", ") + ")";
    i++;
  }
  return result;
}
