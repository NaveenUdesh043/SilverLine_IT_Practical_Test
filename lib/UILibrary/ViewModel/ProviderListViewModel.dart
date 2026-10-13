class ProviderListViewModel extends BaseViewModel {
  ProviderListViewModel(
      this._getProviders, {
        this.filter = const ProviderFilter(),
      });

  final GetProvidersUseCase _getProviders;

  ProviderFilter filter;
  ProviderSort _sort = ProviderSort.ratingHighToLow;
  final List<ServiceProvider> _providers = <ServiceProvider>[];

  int _page = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String? _loadMoreError;
  int _requestId = 0;

  List<ServiceProvider> get providers => List<ServiceProvider>.unmodifiable(
    _providers,
  );
  ProviderSort get sort => _sort;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  String? get loadMoreError => _loadMoreError;
  bool get isEmpty => isSuccess && _providers.isEmpty;
  int get activeFilterCount => filter.activeCount;

  Future<void> loadInitial() async {
    _requestId++;
    final int token = _requestId;
    _providers.clear();
    _page = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _loadMoreError = null;
    setStatus(ViewStatus.loading);

    try {
      final ProviderPage page = await _getProviders(
        GetProvidersParams(page: 1, filter: filter, sort: _sort),
      );
      if (token != _requestId) return;
      _providers.addAll(page.items);
      _page = 1;
      _hasMore = page.hasMore;
      setStatus(ViewStatus.success);
    } catch (error) {
      if (token != _requestId) return;
      setStatus(ViewStatus.error, error: messageFor(error));
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || !isSuccess) return;
    final int token = _requestId;
    _isLoadingMore = true;
    _loadMoreError = null;
    notifyListeners();

    try {
      final ProviderPage page = await _getProviders(
        GetProvidersParams(page: _page + 1, filter: filter, sort: _sort),
      );
      if (token != _requestId) return;
      _providers.addAll(page.items);
      _page++;
      _hasMore = page.hasMore;
      _isLoadingMore = false;
      notifyListeners();
    } catch (error) {
      if (token != _requestId) return;
      _isLoadingMore = false;
      _loadMoreError = messageFor(error);
      notifyListeners();
    }
  }

  Future<void> refresh() => loadInitial();

  void applyFilter(ProviderFilter newFilter) {
    filter = newFilter;
    loadInitial();
  }

  void setSort(ProviderSort sort) {
    _sort = sort;
    loadInitial();
  }

  void clearFilters() {
    filter = filter.clearFilters();
    loadInitial();
  }

  void setQuery(String query) {
    filter = filter.withQuery(query);
    loadInitial();
  }

  void reset() {
    _requestId++;
    _providers.clear();
    _page = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _loadMoreError = null;
    filter = filter.withQuery('');
    setStatus(ViewStatus.idle);
  }
}
