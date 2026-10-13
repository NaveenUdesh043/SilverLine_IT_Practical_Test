
import '../../Core/AppConstants.dart';
import '../../Core/UseCase.dart';
import '../CommonObjets/ProviderFilter.dart';
import '../CommonObjets/ProviderPage.dart';
import '../CommonObjets/ProviderSort.dart';
import '../Repositories/ProviderRepository.dart';

class GetProvidersParams {
  const GetProvidersParams({
    required this.page,
    this.filter = const ProviderFilter(),
    this.sort = ProviderSort.ratingHighToLow,
    this.pageSize = AppConstants.pageSize,
  });

  final int page;
  final ProviderFilter filter;
  final ProviderSort sort;
  final int pageSize;
}

class GetProvidersUseCase implements UseCase<ProviderPage, GetProvidersParams> {
  const GetProvidersUseCase(this._repository);

  final ProviderRepository _repository;

  @override
  Future<ProviderPage> call(GetProvidersParams params) {
    return _repository.getProviders(
      page: params.page,
      filter: params.filter,
      sort: params.sort,
      pageSize: params.pageSize,
    );
  }
}
