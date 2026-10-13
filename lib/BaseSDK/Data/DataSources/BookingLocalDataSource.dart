import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/Entities/BookingStatus.dart';
import '../Models/BookingModel.dart';
import '../Models/ReviewModel.dart';

abstract class BookingLocalDataSource {
  Future<List<BookingModel>> getBookings();

  Future<void> saveBookings(List<BookingModel> bookings);

  Future<List<ReviewModel>> getReviews();

  Future<void> saveReviews(List<ReviewModel> reviews);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl(
      this._prefs, {
        DateTime Function()? now,
        this.seed = true,
      }) : _now = now ?? DateTime.now;

  static const String _bookingsKey = 'bookings_v1';
  static const String _reviewsKey = 'reviews_v1';
  static const String _seededKey = 'seeded_v1';

  final SharedPreferences _prefs;
  final DateTime Function() _now;
  final bool seed;

  Future<void> _ensureSeeded() async {
    if (!seed) return;
    if (_prefs.getBool(_seededKey) ?? false) return;
    final DateTime now = _now();
    await saveBookings(_buildSeedBookings(now));
    await saveReviews(_buildSeedReviews(now));
    await _prefs.setBool(_seededKey, true);
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    await _ensureSeeded();
    return _decodeList(_prefs.getString(_bookingsKey), BookingModel.fromJson);
  }

  @override
  Future<void> saveBookings(List<BookingModel> bookings) async {
    await _prefs.setString(
      _bookingsKey,
      jsonEncode(bookings.map((b) => b.toJson()).toList()),
    );
  }

  @override
  Future<List<ReviewModel>> getReviews() async {
    await _ensureSeeded();
    return _decodeList(_prefs.getString(_reviewsKey), ReviewModel.fromJson);
  }

  @override
  Future<void> saveReviews(List<ReviewModel> reviews) async {
    await _prefs.setString(
      _reviewsKey,
      jsonEncode(reviews.map((r) => r.toJson()).toList()),
    );
  }

  List<T> _decodeList<T>(
      String? raw,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    if (raw == null || raw.isEmpty) return <T>[];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  List<BookingModel> _buildSeedBookings(DateTime now) {
    BookingModel build({
      required String id,
      required String providerId,
      required String providerName,
      required String categoryId,
      required String serviceName,
      required DateTime date,
      required int hours,
      required double rate,
      required BookingStatus status,
      bool reviewed = false,
    }) {
      return BookingModel(
        id: id,
        providerId: providerId,
        providerName: providerName,
        categoryId: categoryId,
        serviceName: serviceName,
        date: date,
        timeSlot: '10:00 AM - 12:00 PM',
        address: '42 Galle Road, Colombo',
        phone: '0771234567',
        notes: '',
        hours: hours,
        hourlyRate: rate,
        status: status,
        createdAt: now.subtract(const Duration(days: 1)),
        reviewed: reviewed,
      );
    }

    return <BookingModel>[
      build(
        id: 'bk_seed_pending',
        providerId: 'p001',
        providerName: 'Naveen Silva',
        categoryId: 'plumbing',
        serviceName: 'Plumbing',
        date: now.add(const Duration(days: 3)),
        hours: 2,
        rate: 3000,
        status: BookingStatus.pending,
      ),
      build(
        id: 'bk_seed_confirmed',
        providerId: 'p003',
        providerName: 'Nehan Fernando',
        categoryId: 'plumbing',
        serviceName: 'Plumbing',
        date: now.add(const Duration(days: 5)),
        hours: 3,
        rate: 2600,
        status: BookingStatus.confirmed,
      ),
      build(
        id: 'bk_seed_soon',
        providerId: 'p002',
        providerName: 'Ruwan Ranasighe',
        categoryId: 'plumbing',
        serviceName: 'Plumbing',
        date: now.add(const Duration(hours: 10)),
        hours: 2,
        rate: 2100,
        status: BookingStatus.pending,
      ),
      build(
        id: 'bk_seed_active',
        providerId: 'p007',
        providerName: 'Chanaka Bandara',
        categoryId: 'electrical',
        serviceName: 'Electrical',
        date: now.add(const Duration(days: 1)),
        hours: 2,
        rate: 2400,
        status: BookingStatus.inProgress,
      ),
      build(
        id: 'bk_seed_completed_unrated',
        providerId: 'p008',
        providerName: 'Dilip Fonseka',
        categoryId: 'electrical',
        serviceName: 'Electrical',
        date: now.subtract(const Duration(days: 5)),
        hours: 2,
        rate: 2800,
        status: BookingStatus.completed,
      ),
      build(
        id: 'bk_seed_completed_rated',
        providerId: 'p013',
        providerName: 'Jagath Cooray',
        categoryId: 'carpentry',
        serviceName: 'Carpentry',
        date: now.subtract(const Duration(days: 10)),
        hours: 4,
        rate: 2700,
        status: BookingStatus.completed,
        reviewed: true,
      ),
      build(
        id: 'bk_seed_cancelled',
        providerId: 'p019',
        providerName: 'Sunil Mendis',
        categoryId: 'painting',
        serviceName: 'Painting',
        date: now.subtract(const Duration(days: 2)),
        hours: 3,
        rate: 4100,
        status: BookingStatus.cancelled,
      ),
    ];
  }

  List<ReviewModel> _buildSeedReviews(DateTime now) {
    const List<List<String>> seed = <List<String>>[
      ['p001', 'Nimal Perera', '5', 'Fixed a nasty leak quickly. Very professional.'],
      ['p001', 'Ayesha Silva', '4', 'Good work, arrived a bit late.'],
      ['p002', 'Kasun Fernando', '4', 'Fair price and clean work.'],
      ['p002', 'Dilani Jayawardena', '5', 'Highly recommend!'],
      ['p003', 'Ruwan de Silva', '4', 'Sorted our bathroom fittings.'],
      ['p004', 'Sachini Herath', '5', 'Excellent plumbing service.'],
      ['p005', 'Thilina Bandara', '4', 'Reasonable and tidy.'],
      ['p006', 'Nadeesha Kumara', '3', 'Did the job, communication could improve.'],
      ['p007', 'Ishara Weerasinghe', '5', 'Rewired the whole house safely.'],
      ['p007', 'Chathura Peiris', '4', 'Great fault finding skills.'],
      ['p008', 'Hasini Mendis', '5', 'Prompt and knowledgeable electrician.'],
      ['p009', 'Lakmal Cooray', '4', 'Good lighting installation.'],
      ['p010', 'Dinuka Fonseka', '4', 'Quick fan installation.'],
      ['p011', 'Sewwandi Rajapaksa', '5', 'Very reliable electrician.'],
      ['p012', 'Pasindu Silva', '4', 'Handled earthing well.'],
      ['p013', 'Menaka Cooray', '5', 'Beautiful custom wardrobe.'],
      ['p019', 'Kavindi Mendis', '4', 'Clean interior paint job.'],
    ];

    final List<ReviewModel> reviews = <ReviewModel>[];
    for (int i = 0; i < seed.length; i++) {
      final List<String> row = seed[i];
      reviews.add(
        ReviewModel(
          id: 'rv_seed_$i',
          providerId: row[0],
          rating: double.parse(row[2]),
          comment: row[3],
          authorName: row[1],
          createdAt: now.subtract(Duration(days: 8 + i)),
        ),
      );
    }
    return reviews;
  }
}
