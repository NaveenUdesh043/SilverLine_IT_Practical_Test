import 'dart:math';

final Random _random = Random();

String generateId([String prefix = '']) {
  final String time =
  DateTime.now().microsecondsSinceEpoch.toRadixString(36);

  final String salt =
  _random.nextInt(1 << 32).toRadixString(36);
  return '$prefix$time$salt';
}
