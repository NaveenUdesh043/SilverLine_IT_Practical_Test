
import '../../Domain/Entities/Booking.dart';
import '../../Domain/Entities/Review.dart';
import '../../Domain/Repositories/BookingRepository.dart';
import '../DataSources/BookingLocalDataSource.dart';
import '../Models/BookingModel.dart';
import '../Models/ReviewModel.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._dataSource);

  final BookingLocalDataSource _dataSource;

  @override
  Future<List<Booking>> getBookings() async {
    final List<BookingModel> models = await _dataSource.getBookings();
    return models.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<Booking?> getBookingById(String id) async {
    final List<BookingModel> models = await _dataSource.getBookings();
    for (final BookingModel model in models) {
      if (model.id == id) return model.toEntity();
    }
    return null;
  }

  @override
  Future<void> saveBooking(Booking booking) async {
    final List<BookingModel> models = await _dataSource.getBookings();
    final List<BookingModel> updated = List<BookingModel>.from(models);
    final int index = updated.indexWhere((m) => m.id == booking.id);
    final BookingModel model = BookingModel.fromEntity(booking);
    if (index == -1) {
      updated.add(model);
    } else {
      updated[index] = model;
    }
    await _dataSource.saveBookings(updated);
  }

  @override
  Future<List<Review>> getReviewsForProvider(String providerId) async {
    final List<ReviewModel> models = await _dataSource.getReviews();
    final List<Review> reviews = models
        .where((m) => m.providerId == providerId)
        .map((m) => m.toEntity())
        .toList();
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }

  @override
  Future<void> addReview(Review review) async {
    final List<ReviewModel> models = await _dataSource.getReviews();
    final List<ReviewModel> updated = List<ReviewModel>.from(models)
      ..add(ReviewModel.fromEntity(review));
    await _dataSource.saveReviews(updated);
  }
}
