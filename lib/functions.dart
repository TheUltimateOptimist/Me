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
