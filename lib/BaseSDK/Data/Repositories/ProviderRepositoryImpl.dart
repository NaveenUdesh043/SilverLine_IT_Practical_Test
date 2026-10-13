import '../../Core/AppFailure.dart';
import '../DataSources/ProviderLocalDataSource.dart';
import '../DataSources/RatingLocalDataSource.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  ProviderRepositoryImpl(this._dataSource, this._ratingStore);

  final ProviderLocalDataSource _dataSource;
  final RatingLocalDataSource _ratingStore;

  @override
  Future<List<ServiceCategory>> getCategories() async {
    try {
      final List<CategoryModel> models = await _dataSource.fetchCategories();
      return models.map((m) => m.toEntity()).toList(growable: false);
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<ProviderPage> getProviders({
    required int page,
    required ProviderFilter filter,
    required ProviderSort sort,
    int pageSize = AppConstants.pageSize,
  }) async {
    final List<ServiceProvider> all = await _loadProviders();

    final List<ServiceProvider> matching =
    all.where((provider) => _matches(provider, filter)).toList();
    _sort(matching, sort);

    final int start = (page - 1) * pageSize;
    if (start >= matching.length) {
      return ProviderPage(
        items: const <ServiceProvider>[],
        page: page,
        hasMore: false,
        totalCount: matching.length,
      );
    }
    final int end = (start + pageSize).clamp(0, matching.length);
    return ProviderPage(
      items: matching.sublist(start, end),
      page: page,
      hasMore: end < matching.length,
      totalCount: matching.length,
    );
  }

  @override
  Future<ServiceProvider> getProviderById(String id) async {
    final List<ServiceProvider> all = await _loadProviders();
    for (final ServiceProvider provider in all) {
      if (provider.id == id) return provider;
    }
    throw const NotFoundFailure('Provider not found.');
  }

  @override
  Future<void> updateRating({
    required String providerId,
    required double rating,
    required int reviewCount,
  }) {
    return _ratingStore.save(
      providerId: providerId,
      rating: rating,
      reviewCount: reviewCount,
    );
  }

  Future<List<ServiceProvider>> _loadProviders() async {
    final List<ProviderModel> models = await _dataSource.fetchProviders();
    final Map<String, RatingOverride> overrides = await _ratingStore.readAll();
    return models.map((model) {
      final ServiceProvider entity = model.toEntity();
      final RatingOverride? override = overrides[entity.id];
      if (override == null) return entity;
      return entity.copyWith(
        rating: override.rating,
        reviewCount: override.reviewCount,
      );
    }).toList();
  }

  bool _matches(ServiceProvider provider, ProviderFilter filter) {
    if (filter.categoryId != null &&
        provider.categoryId != filter.categoryId) {
      return false;
    }
    if (filter.minRating != null && provider.rating < filter.minRating!) {
      return false;
    }
    if (!filter.matchesRate(provider.hourlyRate)) {
      return false;
    }
    if (filter.availableOnly && !provider.isAvailable) {
      return false;
    }
    if (filter.hasQuery) {
      final String query = filter.query.trim().toLowerCase();
      final bool byName = provider.name.toLowerCase().contains(query);
      final bool bySkill = provider.skills
          .any((skill) => skill.toLowerCase().contains(query));
      if (!byName && !bySkill) return false;
    }
    return true;
  }

  void _sort(List<ServiceProvider> providers, ProviderSort sort) {
    switch (sort) {
      case ProviderSort.ratingHighToLow:
        providers.sort((a, b) => b.rating.compareTo(a.rating));
      case ProviderSort.rateLowToHigh:
        providers.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
      case ProviderSort.experienceHighToLow:
        providers.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
    }
  }
}
