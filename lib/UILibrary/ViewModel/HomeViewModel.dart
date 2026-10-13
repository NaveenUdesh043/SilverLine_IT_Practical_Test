
import '../../BaseSDK/Core/Debouncer.dart';
import '../../BaseSDK/Domain/UseCases/GetProvidersUseCase.dart';
import 'BaseViewModel.dart';
import 'ProviderListViewModel.dart';

class HomeViewModel extends BaseViewModel {

  HomeViewModel(GetProvidersUseCase getProviders)
      : search = ProviderListViewModel(getProviders) {
    search.addListener(_forward);
  }

  final ProviderListViewModel search;
  final Debouncer _debouncer = Debouncer();

  String _query = '';

  String get query => _query;
  bool get isSearching => _query.trim().isNotEmpty;

  void _forward() => notifyListeners();

  void onQueryChanged(String value) {
    _query = value;
    notifyListeners();
    _debouncer.run(() {
      if (value.trim().isEmpty) {
        search.reset();
      } else {
        search.setQuery(value);
      }
    });
  }

  void clearQuery() => onQueryChanged('');

  @override
  void dispose() {
    _debouncer.dispose();
    search.removeListener(_forward);
    search.dispose();
    super.dispose();
  }
}
