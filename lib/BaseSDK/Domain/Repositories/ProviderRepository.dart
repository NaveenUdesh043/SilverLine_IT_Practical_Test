import '../CommonObjets/ProviderFilter.dart';
import '../CommonObjets/ProviderPage.dart';
import '../CommonObjets/ProviderSort.dart';
import '../Entities/ServiceCategory.dart';
import '../Entities/ServiceProvider.dart';

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
