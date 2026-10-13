
import '../../Core/GenerateId.dart';
import '../../Core/UseCase.dart';
import '../Entities/Booking.dart';
import '../Entities/BookingStatus.dart';
import '../Repositories/BookingRepository.dart';

class CreateBooking {
  const CreateBooking({
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
  });

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
}

class CreateBookingUseCase implements UseCase<Booking, CreateBooking> {
  CreateBookingUseCase(
      this._repository, {
        DateTime Function()? now,
        String Function()? idGenerator,
      })  : _now = now ?? DateTime.now,
        _generateId = idGenerator ?? _defaultId;

  final BookingRepository _repository;
  final DateTime Function() _now;
  final String Function() _generateId;

  static String _defaultId() => generateId('b_');

  @override
  Future<Booking> call(CreateBooking params) async {
    final Booking booking = Booking(
      id: _generateId(),
      providerId: params.providerId,
      providerName: params.providerName,
      categoryId: params.categoryId,
      serviceName: params.serviceName,
      date: params.date,
      timeSlot: params.timeSlot,
      address: params.address,
      phone: params.phone,
      notes: params.notes,
      hours: params.hours,
      hourlyRate: params.hourlyRate,
      status: BookingStatus.pending,
      createdAt: _now(),
    );
    await _repository.saveBooking(booking);
    return booking;
  }
}
