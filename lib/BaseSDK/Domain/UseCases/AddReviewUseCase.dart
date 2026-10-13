
class AddReview {
  const AddReview({
    required this.bookingId,
    required this.providerId,
    required this.rating,
    this.comment = '',
  });

  final String bookingId;
  final String providerId;
  final double rating;
  final String comment;
}

class AddReviewUseCase implements UseCase<Review, AddReview> {
  AddReviewUseCase(
      this._bookingRepository,
      this._providerRepository, {
        DateTime Function()? now,
        String Function()? idGenerator,
      })  : _now = now ?? DateTime.now,
        _generateId = idGenerator ?? _defaultId;

  final BookingRepository _bookingRepository;
  final ProviderRepository _providerRepository;
  final DateTime Function() _now;
  final String Function() _generateId;

  static String _defaultId() => generateId('r_');

  @override
  Future<Review> call(AddReview params) async {
    final Booking? booking =
    await _bookingRepository.getBookingById(params.bookingId);
    if (booking == null) {
      throw const NotFoundFailure('Booking not found.');
    }
    if (booking.status != BookingStatus.completed) {
      throw const ValidationFailure(
        'Only completed bookings can be reviewed.',
      );
    }
    if (booking.reviewed) {
      throw const ValidationFailure('This booking was already reviewed.');
    }

    final Review review = Review(
      id: _generateId(),
      providerId: params.providerId,
      bookingId: booking.id,
      rating: params.rating,
      comment: params.comment,
      createdAt: _now(),
    );
    await _bookingRepository.addReview(review);
    await _bookingRepository.saveBooking(booking.copyWith(reviewed: true));

    await _recalculateProviderRating(params.providerId, params.rating);
    return review;
  }

  Future<void> _recalculateProviderRating(
      String providerId,
      double newRating,
      ) async {
    final ServiceProvider provider =
    await _providerRepository.getProviderById(providerId);
    final int newCount = provider.reviewCount + 1;
    final double weighted =
        ((provider.rating * provider.reviewCount) + newRating) / newCount;
    await _providerRepository.updateRating(
      providerId: providerId,
      rating: double.parse(weighted.toStringAsFixed(1)),
      reviewCount: newCount,
    );
  }
}
