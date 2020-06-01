import 'package:timeago/timeago.dart' as timeago;

class CustomEn extends timeago.EnMessages {
  @override
  String suffixAgo() => '';
  String lessThanOneMinute(int seconds) => '${seconds}s';
  String minutes(int minutes) => '${minutes}m';
  String aboutAnHour(int hour) => '1h';
  String hours(int hours) => '${hours}h';
  String aDay(int day) => '1d';
  String days(int days) => '${days}d';
  String weeks(int weeks) => '${weeks}w';
  String aboutAMonth(int weeks) => '1m';
  String months(int months) => '${months}m';
  String aboutAYear(int years) => '1y';
  String years(int years) => '${years}y';
}