import '../Entities/ServiceCategory.dart';

abstract class ProviderRepository {
  Future<List<ServiceCategory>> getCategories();

  Future<ProviderPage> getProviders({
    required int page,
    required ProviderFilter filter,
    required ProviderSort sort,
    int pageSize,
  });

  Future<ServiceProvider> getProviderById(String id);

  Future<void> updateRating({
    required String providerId,
    required double rating,
    required int reviewCount,
  });
}
