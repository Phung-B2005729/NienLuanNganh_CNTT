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

  static String getStringFormDateTime(DateTime timeDate) {
    return DateFormat('dd/MM/yyyy').format(timeDate);
  }

  static String getGioFormDateTime(DateTime timeDate) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timeDate);
  }

  static DateTime getDateTimeFormString(String time) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    return format.parse(time);
  }

  static String getTimeFormatDatabase(int timeint) {
    DateTime time = getTimeToDateTime(timeint);
    return getTimeFormat(time);
  }
}
