import '../../Core/UseCase.dart';
import '../Entities/ServiceCategory.dart';
import '../Repositories/ProviderRepository.dart';

class GetCategoriesUseCase implements UseCase<List<ServiceCategory>, NoParams> {
  const GetCategoriesUseCase(this._repository);

  final ProviderRepository _repository;

  @override
  Future<List<ServiceCategory>> call(NoParams params) =>
      _repository.getCategories();
}
