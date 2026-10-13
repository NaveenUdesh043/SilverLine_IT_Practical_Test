import '../../Core/UseCase.dart';
import '../Entities/Booking.dart';
import '../Entities/BookingStatus.dart';
import '../Repositories/BookingRepository.dart';

class GetBookingsUseCase implements UseCase<List<Booking>, NoParams> {
  const GetBookingsUseCase(this._repository);

  final BookingRepository _repository;

  @override
  Future<List<Booking>> call(NoParams params) async {
    final List<Booking> bookings = await _repository.getBookings();
    bookings.sort((a, b) => b.date.compareTo(a.date));
    return bookings;
  }
}

extension BookingCollections on List<Booking> {
  List<Booking> get upcoming =>
      where((b) => b.status.isUpcoming).toList(growable: false);

  List<Booking> get history =>
      where((b) => b.status.isHistory).toList(growable: false);

  List<Booking> get active => where((b) => b.status.isUpcoming).toList(
    growable: false,
  );

  List<BookingStatus> get statuses =>
      map((b) => b.status).toList(growable: false);
}
