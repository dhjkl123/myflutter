import 'dart:math' as math;

class Utils {
  static String makeTwoDigit(int number) {
    return number.toString().padLeft(2, "0");
  }

  static int getFormatTime(DateTime time) {
    return int.parse(
        "${time.year}${makeTwoDigit(time.month)}${makeTwoDigit(time.day)}");
  }

  static String stringToDateTime(String date) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));

    DateTime dt = DateTime(year, month, day);

    return "${dt.month}월 ${dt.day}일";
  }
}
