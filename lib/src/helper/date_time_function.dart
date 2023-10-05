import 'package:intl/intl.dart';

class DatetimeFunction {
  final DateTime? time;
  DatetimeFunction({this.time});

  static int getTimeToInt(DateTime timenow) {
    return timenow.millisecondsSinceEpoch;
  }

  static DateTime getTimeToDateTime(int timeint) {
    return DateTime.fromMillisecondsSinceEpoch(timeint);
  }

  static String getTimeFormat(DateTime timeDate) {
    return DateFormat('dd-MM-yyyy').format(timeDate);
  }

  static String getTimeFormatDatabase(int timeint) {
    DateTime time = getTimeToDateTime(timeint);
    return getTimeFormat(time);
  }
}
