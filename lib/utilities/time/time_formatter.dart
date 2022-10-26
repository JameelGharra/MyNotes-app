abstract class TimeFormatter {
  static String _toTwoDigits(final String time) {
    return time.padLeft(2, '0');
  }

  static String toCurrentTime(DateTime time) {
    return "${_toTwoDigits(time.hour.toString())}:${_toTwoDigits(time.minute.toString())}";
  }

  static String toCurrentDate(DateTime time) {
    return "${_toTwoDigits(time.day.toString())}/${_toTwoDigits(time.month.toString())}/${_toTwoDigits(time.year.toString())}";
  }
}
