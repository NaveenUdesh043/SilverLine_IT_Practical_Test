import '../Entities/ServiceProvider.dart';

class ProviderPage {
  const ProviderPage({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.totalCount,
  });

  final List<ServiceProvider> items;
  final int page;
  final bool hasMore;
  final int totalCount;
}
