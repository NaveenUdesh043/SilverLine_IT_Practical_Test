
import '../Entities/Booking.dart';
import '../Entities/Review.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();

  Future<Booking?> getBookingById(String id);

  Future<void> saveBooking(Booking booking);

  Future<List<Review>> getReviewsForProvider(String providerId);

  Future<void> addReview(Review review);
}
