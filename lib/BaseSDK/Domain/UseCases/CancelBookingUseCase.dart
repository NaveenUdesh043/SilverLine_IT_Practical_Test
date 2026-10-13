
import '../../Core/AppFailure.dart';
import '../../Core/UseCase.dart';
import '../Entities/Booking.dart';
import '../Entities/BookingStatus.dart';
import '../Repositories/BookingRepository.dart';

class CancelBookingUseCase implements UseCase<Booking, String> {
  CancelBookingUseCase(this._repository, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final BookingRepository _repository;
  final DateTime Function() _now;

  @override
  Future<Booking> call(String bookingId) async {
    final Booking? booking = await _repository.getBookingById(bookingId);
    if (booking == null) {
      throw const NotFoundFailure('Booking not found.');
    }
    if (!booking.status.canBeCancelledByCustomer) {
      throw const ValidationFailure(
        'Only pending or confirmed bookings can be cancelled.',
      );
    }
    if (!booking.canBeCancelled(_now())) {
      throw const ValidationFailure(
        'Bookings can only be cancelled more than 24 hours in advance.',
      );
    }
    final Booking updated = booking.copyWith(status: BookingStatus.cancelled);
    await _repository.saveBooking(updated);
    return updated;
  }
}
