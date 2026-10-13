import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class RatingLocalDataSource {
  Future<Map<String, RatingOverride>> readAll();

  Future<void> save({
    required String providerId,
    required double rating,
    required int reviewCount,
  });
}

class RatingOverride {
  const RatingOverride({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;
}

class RatingLocalDataSourceImpl implements RatingLocalDataSource {
  RatingLocalDataSourceImpl(this._prefs);

  static const String _key = 'provider_rating_overrides';

  final SharedPreferences _prefs;

  @override
  Future<Map<String, RatingOverride>> readAll() async {
    final String? raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <String, RatingOverride>{};
    final Map<String, dynamic> decoded =
    jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) {
      final Map<String, dynamic> entry = value as Map<String, dynamic>;
      return MapEntry(
        key,
        RatingOverride(
          rating: (entry['rating'] as num).toDouble(),
          reviewCount: (entry['reviewCount'] as num).toInt(),
        ),
      );
    });
  }

  @override
  Future<void> save({
    required String providerId,
    required double rating,
    required int reviewCount,
  }) async {
    final Map<String, RatingOverride> overrides = await readAll();
    overrides[providerId] =
        RatingOverride(rating: rating, reviewCount: reviewCount);
    final Map<String, dynamic> encoded = overrides.map(
          (key, value) => MapEntry(
        key,
        <String, dynamic>{'rating': value.rating, 'reviewCount': value.reviewCount},
      ),
    );
    await _prefs.setString(_key, jsonEncode(encoded));
  }
}
