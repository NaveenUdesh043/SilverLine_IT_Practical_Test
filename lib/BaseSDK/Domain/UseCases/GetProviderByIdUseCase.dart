import '../../Core/UseCase.dart';
import '../Entities/ServiceProvider.dart';
import '../Repositories/ProviderRepository.dart';

class GetProviderByIdUseCase implements UseCase<ServiceProvider, String> {
  const GetProviderByIdUseCase(this._repository);

  final ProviderRepository _repository;

  @override
  Future<ServiceProvider> call(String params) =>
      _repository.getProviderById(params);
}
