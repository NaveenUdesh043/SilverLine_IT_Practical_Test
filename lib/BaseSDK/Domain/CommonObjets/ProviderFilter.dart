
import '../../Core/AppConstants.dart';

class ProviderFilter {
  const ProviderFilter({
    this.categoryId,
    this.minRating,
    this.minHourlyRate,
    this.maxHourlyRate,
    this.availableOnly = false,
    this.query = '',
  });

  final String? categoryId;
  final double? minRating;
  final double? minHourlyRate;
  final double? maxHourlyRate;
  final bool availableOnly;
  final String query;

  bool get hasRateRange => minHourlyRate != null || maxHourlyRate != null;

  bool get hasQuery => query.trim().isNotEmpty;

  int get activeCount {
    int count = 0;
    if (categoryId != null) count++;
    if (minRating != null) count++;
    if (hasRateRange) count++;
    if (availableOnly) count++;
    return count;
  }

  bool get isEmpty => activeCount == 0;

  ProviderFilter copyWith({
    String? categoryId,
    double? minRating,
    double? minHourlyRate,
    double? maxHourlyRate,
    bool? availableOnly,
    String? query,
  }) {
    return ProviderFilter(
      categoryId: categoryId ?? this.categoryId,
      minRating: minRating ?? this.minRating,
      minHourlyRate: minHourlyRate ?? this.minHourlyRate,
      maxHourlyRate: maxHourlyRate ?? this.maxHourlyRate,
      availableOnly: availableOnly ?? this.availableOnly,
      query: query ?? this.query,
    );
  }

  /// Clears every filter except the free-text query.
  ProviderFilter clearFilters() => ProviderFilter(query: query);

  ProviderFilter withQuery(String value) => ProviderFilter(
    categoryId: categoryId,
    minRating: minRating,
    minHourlyRate: minHourlyRate,
    maxHourlyRate: maxHourlyRate,
    availableOnly: availableOnly,
    query: value,
  );

  bool matchesRate(double rate) {
    if (minHourlyRate != null && rate < minHourlyRate!) return false;
    if (maxHourlyRate != null && rate > maxHourlyRate!) return false;
    return true;
  }

  double get resolvedMinRate => minHourlyRate ?? AppConstants.minHourlyRate;

  double get resolvedMaxRate => maxHourlyRate ?? AppConstants.maxHourlyRate;

  @override
  bool operator ==(Object other) =>
      other is ProviderFilter &&
          other.categoryId == categoryId &&
          other.minRating == minRating &&
          other.minHourlyRate == minHourlyRate &&
          other.maxHourlyRate == maxHourlyRate &&
          other.availableOnly == availableOnly &&
          other.query == query;

  @override
  int get hashCode => Object.hash(
    categoryId,
    minRating,
    minHourlyRate,
    maxHourlyRate,
    availableOnly,
    query,
  );
}
