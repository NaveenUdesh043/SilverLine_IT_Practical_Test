class Review {
  const Review({
    required this.id,
    required this.providerId,
    required this.rating,
    required this.createdAt,
    this.bookingId,
    this.comment = '',
    this.authorName = 'You',
  });

  final String id;
  final String providerId;
  final String? bookingId;
  final double rating;
  final String comment;
  final String authorName;
  final DateTime createdAt;
}
