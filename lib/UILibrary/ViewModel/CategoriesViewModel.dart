
import '../../BaseSDK/Core/UseCase.dart';
import '../../BaseSDK/Domain/Entities/ServiceCategory.dart';
import '../../BaseSDK/Domain/UseCases/GetCategoriesUseCase.dart';
import 'BaseViewModel.dart';

class CategoriesViewModel extends BaseViewModel {
  CategoriesViewModel(this._getCategories) {
    load();
  }

  final GetCategoriesUseCase _getCategories;

  List<ServiceCategory> _categories = <ServiceCategory>[];

  List<ServiceCategory> get categories =>
      List<ServiceCategory>.unmodifiable(_categories);

  Future<void> load() async {
    if (isLoading) return;
    setStatus(ViewStatus.loading);
    try {
      _categories = await _getCategories(const NoParams());
      setStatus(ViewStatus.success);
    } catch (error) {
      setStatus(ViewStatus.error, error: messageFor(error));
    }
  }
}
