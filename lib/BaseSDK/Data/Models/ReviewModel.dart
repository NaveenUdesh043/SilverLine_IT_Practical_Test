
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.providerId,
    required this.rating,
    required this.createdAt,
    this.bookingId,
    this.comment = '',
    this.authorName = 'You',
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['id'] as String,
    providerId: json['providerId'] as String,
    bookingId: json['bookingId'] as String?,
    rating: (json['rating'] as num).toDouble(),
    comment: json['comment'] as String? ?? '',
    authorName: json['authorName'] as String? ?? 'You',
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  factory ReviewModel.fromEntity(Review review) => ReviewModel(
    id: review.id,
    providerId: review.providerId,
    bookingId: review.bookingId,
    rating: review.rating,
    comment: review.comment,
    authorName: review.authorName,
    createdAt: review.createdAt,
  );

  final String id;
  final String providerId;
  final String? bookingId;
  final double rating;
  final String comment;
  final String authorName;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'providerId': providerId,
    'bookingId': bookingId,
    'rating': rating,
    'comment': comment,
    'authorName': authorName,
    'createdAt': createdAt.toIso8601String(),
  };

  Review toEntity() => Review(
    id: id,
    providerId: providerId,
    bookingId: bookingId,
    rating: rating,
    comment: comment,
    authorName: authorName,
    createdAt: createdAt,
  );
}
