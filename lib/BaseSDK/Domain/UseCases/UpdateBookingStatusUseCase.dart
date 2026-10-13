import '../../Core/AppFailure.dart';
import '../../Core/UseCase.dart';
import '../Entities/Booking.dart';
import '../Entities/BookingStatus.dart';
import '../Repositories/BookingRepository.dart';

class UpdateBookingStatusParams {
  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  final String bookingId;
  final BookingStatus status;
}

class UpdateBookingStatusUseCase
    implements UseCase<Booking, UpdateBookingStatusParams> {
  const UpdateBookingStatusUseCase(this._repository);

  final BookingRepository _repository;

  @override
  Future<Booking> call(UpdateBookingStatusParams params) async {
    final Booking? booking =
    await _repository.getBookingById(params.bookingId);
    if (booking == null) {
      throw const NotFoundFailure('Booking not found.');
    }
    final Booking updated = booking.copyWith(status: params.status);
    await _repository.saveBooking(updated);
    return updated;
  }
}