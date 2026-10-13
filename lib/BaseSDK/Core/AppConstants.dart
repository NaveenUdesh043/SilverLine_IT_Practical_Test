class AppConstants {
  AppConstants._();

  static const String providersAssetPath = 'assets/data/providers.json';
  static const Duration minNetworkDelay = Duration(milliseconds: 800);
  static const Duration maxNetworkDelay = Duration(milliseconds: 1500);
  static const double failureRate = 0.2;
  static const int pageSize = 10;
  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const Duration cancellationCutoff = Duration(hours: 24);
  static const int minBookingHours = 1;
  static const int maxBookingHours = 12;
  static const double minHourlyRate = 2000;
  static const double maxHourlyRate = 5000;
  static const double ratingFilterFloor = 1.0;
  static const double ratingFilterCeil = 5.0;

  static const List<String> timeSlots = <String>[
    '08:00 AM - 10:00 AM',
    '10:15 AM - 12:15 PM',
    '12:30 PM - 02:30 PM',
    '02:45 PM - 04:45 PM',
    '05:00 PM - 07:00 PM',
  ];

  static const List<double> ratingFilterOptions = <double>[3.0, 4.0, 4.5];
}
