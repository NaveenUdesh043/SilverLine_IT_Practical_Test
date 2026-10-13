import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Theme/CommonVisuals.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Widgets/BottomBar.dart';

import '../../../BaseSDK/Domain/CommonObjets/ProviderFilter.dart';
import '../../../BaseSDK/Domain/CommonObjets/ProviderSort.dart';
import '../../../BaseSDK/Domain/Entities/ServiceCategory.dart';
import '../../../BaseSDK/Domain/Entities/ServiceProvider.dart';
import '../../../BaseSDK/Domain/UseCases/GetProvidersUseCase.dart';
import '../../ViewModel/CategoriesViewModel.dart';
import '../../ViewModel/ProviderListViewModel.dart';
import '../Widgets/EmptyView.dart';
import '../Widgets/ErrorView.dart';
import '../Widgets/FilterBottomSheet.dart';
import '../Widgets/LoadingView.dart';
import '../Widgets/ProviderCard.dart';
import 'ProviderDetailScreen.dart';

class ProviderListScreen extends StatelessWidget {
  const ProviderListScreen({
    super.key,
    this.initialFilter = const ProviderFilter(),
  });

  final ProviderFilter initialFilter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderListViewModel>(
      create: (context) => ProviderListViewModel(
        context.read<GetProvidersUseCase>(),
        filter: initialFilter,
      )..loadInitial(),
      child: const _ProviderListView(),
    );
  }
}

class _ProviderListView extends StatefulWidget {
  const _ProviderListView();

  @override
  State<_ProviderListView> createState() => _ProviderListViewState();
}

class _ProviderListViewState extends State<_ProviderListView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final double threshold = _controller.position.maxScrollExtent - 400;
    if (_controller.position.pixels >= threshold) {
      context.read<ProviderListViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProviderListViewModel vm = context.watch<ProviderListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(vm)),
        actions: <Widget>[
          IconButton(
            tooltip: 'Sort',
            onPressed: vm.isLoading ? null : () => _changeSort(vm),
            icon: const Icon(Icons.sort_rounded),
          ),
          _FilterButton(vm: vm),
          const SizedBox(width: 4),
        ],
        bottom: vm.activeFilterCount > 0
            ? PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _ActiveFilterBar(vm: vm),
        )
            : null,
      ),
      body: _buildBody(vm),
    );
  }

  String _title(ProviderListViewModel vm) {
    final String? categoryId = vm.filter.categoryId;
    if (categoryId != null) return CommonVisuals.nameFor(categoryId);
    return 'Providers';
  }

  Widget _buildBody(ProviderListViewModel vm) {
    if (vm.isLoading || vm.isIdle) {
      return const LoadingView(label: 'Finding providers...');
    }
    if (vm.hasError) {
      return ErrorView(
        message: vm.errorMessage ?? 'Could not load providers.',
        onRetry: vm.loadInitial,
      );
    }

    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          if (vm.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyView(
                icon: Icons.search_off_rounded,
                title: 'No providers found',
                subtitle: 'Try adjusting or clearing your filters.',
                action: vm.activeFilterCount > 0
                    ? OutlinedButton(
                  onPressed: vm.clearFilters,
                  child: const Text('Clear Filters'),
                )
                    : null,
              ),
            )
          else
            ...vm.providers.map(
                  (ServiceProvider provider) => ProviderCard(
                provider: provider,
                onTap: () => _openDetail(provider),
              ),
            ),
          if (!vm.isEmpty)
            BottomBar(
              isLoadingMore: vm.isLoadingMore,
              hasMore: vm.hasMore,
              errorMessage: vm.loadMoreError,
              onRetry: vm.loadMore,
            ),
        ],
      ),
    );
  }

  void _openDetail(ServiceProvider provider) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProviderDetailScreen(
          providerId: provider.id,
          providerName: provider.name,
        ),
      ),
    );
  }

  Future<void> _changeSort(ProviderListViewModel vm) async {
    final ProviderSort? sort = await showSortSheet(context, current: vm.sort);
    if (sort != null) vm.setSort(sort);
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.vm});

  final ProviderListViewModel vm;

  @override
  Widget build(BuildContext context) {
    final int count = vm.activeFilterCount;
    return IconButton(
      tooltip: 'Filter',
      onPressed: () => _open(context, vm),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.tune_rounded),
      ),
    );
  }

  Future<void> _open(BuildContext context, ProviderListViewModel vm) async {
    final List<ServiceCategory> categories =
        context.read<CategoriesViewModel>().categories;
    final ProviderFilter? result = await showFilterSheet(
      context,
      current: vm.filter,
      categories: categories,
    );
    if (result != null) vm.applyFilter(result);
  }
}

class _ActiveFilterBar extends StatelessWidget {
  const _ActiveFilterBar({required this.vm});

  final ProviderListViewModel vm;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Icon(Icons.filter_alt_rounded,
              size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            '${vm.activeFilterCount} '
                'filter${vm.activeFilterCount > 1 ? 's' : ''} active',
            style: theme.textTheme.bodySmall,
          ),
          const Spacer(),
          TextButton(
            onPressed: vm.clearFilters,
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
