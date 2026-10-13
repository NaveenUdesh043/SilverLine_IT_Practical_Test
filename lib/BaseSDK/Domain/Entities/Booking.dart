

import '../../Core/AppConstants.dart';

class Booking {
  const Booking({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.categoryId,
    required this.serviceName,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.phone,
    required this.notes,
    required this.hours,
    required this.hourlyRate,
    required this.status,
    required this.createdAt,
    this.reviewed = false,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String categoryId;
  final String serviceName;
  final DateTime date;
  final String timeSlot;
  final String address;
  final String phone;
  final String notes;
  final int hours;
  final double hourlyRate;
  final BookingStatus status;
  final DateTime createdAt;
  final bool reviewed;

  double get totalCost => hourlyRate * hours;

  bool canBeCancelled(DateTime now) {
    if (!status.canBeCancelledByCustomer) return false;
    return date.isAfter(now.add(AppConstants.cancellationCutoff));
  }

  Booking copyWith({BookingStatus? status, bool? reviewed}) {
    return Booking(
      id: id,
      providerId: providerId,
      providerName: providerName,
      categoryId: categoryId,
      serviceName: serviceName,
      date: date,
      timeSlot: timeSlot,
      address: address,
      phone: phone,
      notes: notes,
      hours: hours,
      hourlyRate: hourlyRate,
      status: status ?? this.status,
      createdAt: createdAt,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}
