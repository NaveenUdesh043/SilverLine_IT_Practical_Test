import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_LK',
    symbol: 'LKR ',
    decimalDigits: 0,
  );

  static final DateFormat _date = DateFormat('EEE, d MMM yyyy');
  static final DateFormat _dateTime = DateFormat('d MMM yyyy, h:mm a');

  static String currency(num value) => _currency.format(value);

  static String date(DateTime value) => _date.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value);

  static String rating(double value) => value.toStringAsFixed(1);
}
