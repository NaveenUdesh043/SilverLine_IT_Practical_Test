
import 'AppConstants.dart';

class Validations {
  Validations._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? address(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Service address is required';
    if (text.length < 5) return 'Address looks too short';
    return null;
  }

  static String? phone(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required';
    final RegExp digitsOnly = RegExp(r'^\d{9,10}$');
    if (!digitsOnly.hasMatch(text)) {
      return 'Enter a valid 9-10 digit phone number';
    }
    return null;
  }

  static String? bookingHours(int hours) {
    if (hours < AppConstants.minBookingHours ||
        hours > AppConstants.maxBookingHours) {
      return 'Choose between ${AppConstants.minBookingHours} and '
          '${AppConstants.maxBookingHours} hours';
    }
    return null;
  }

  /// Booking date must be at least 24 hours away.
  static String? bookingDate(DateTime? date, DateTime now) {
    if (date == null) return 'Please select a date';
    final DateTime earliest = now.add(AppConstants.cancellationCutoff);
    if (date.isBefore(earliest)) {
      return 'Bookings must be at least 24 hours in advance';
    }
    return null;
  }

  static String? timeSlot(String? slot) {
    if (slot == null || slot.isEmpty) return 'Please pick a time slot';
    return null;
  }
}
