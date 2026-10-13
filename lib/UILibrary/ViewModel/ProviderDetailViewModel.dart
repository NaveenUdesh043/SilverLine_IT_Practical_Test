
import '../../BaseSDK/Domain/Entities/Review.dart';
import '../../BaseSDK/Domain/Entities/ServiceProvider.dart';
import '../../BaseSDK/Domain/UseCases/GetProviderByIdUseCase.dart';
import '../../BaseSDK/Domain/UseCases/GetProviderReviewsUseCase.dart';
import 'BaseViewModel.dart';

class ProviderDetailViewModel extends BaseViewModel {
  ProviderDetailViewModel(this._getProvider, this._getReviews);

  final GetProviderByIdUseCase _getProvider;
  final GetProviderReviewsUseCase _getReviews;

  ServiceProvider? _provider;
  List<Review> _reviews = <Review>[];

  ServiceProvider? get provider => _provider;
  List<Review> get reviews => List<Review>.unmodifiable(_reviews);
  bool get canBook => _provider != null && _provider!.isAvailable;

  Future<void> load(String providerId) async {
    setStatus(ViewStatus.loading);
    try {
      final ServiceProvider provider = await _getProvider(providerId);
      final List<Review> reviews = await _getReviews(providerId);
      _provider = provider;
      _reviews = reviews;
      setStatus(ViewStatus.success);
    } catch (error) {
      setStatus(ViewStatus.error, error: messageFor(error));
    }
  }

  Future<void> refresh(String providerId) => load(providerId);
}
