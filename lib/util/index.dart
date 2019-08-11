class Utils {
  static String parseTimestamp(int timestamp, [ bool withWeekday = false ]) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var weeks = ['星期一','星期二','星期三','星期四','星期五','星期六','星期日'];
    int y = date.year;
    int m = date.month;
    int d = date.day;
    String weekDay = weeks[date.weekday - 1];
    if (withWeekday) {
      return '$y-$m-$d $weekDay';
    }
    return '$y-$m-$d';
  }
}