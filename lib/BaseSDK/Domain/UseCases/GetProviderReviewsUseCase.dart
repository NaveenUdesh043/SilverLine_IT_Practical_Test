
import '../../Core/UseCase.dart';
import '../Entities/Review.dart';
import '../Repositories/BookingRepository.dart';

class GetProviderReviewsUseCase implements UseCase<List<Review>, String> {
  const GetProviderReviewsUseCase(this._repository);

  final BookingRepository _repository;

  @override
  Future<List<Review>> call(String params) =>
      _repository.getReviewsForProvider(params);
}
