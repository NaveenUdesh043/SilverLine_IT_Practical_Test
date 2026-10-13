import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(context.read<GetProvidersUseCase>()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _results = ScrollController();

  @override
  void initState() {
    super.initState();
    _results.addListener(_onScroll);
  }

  @override
  void dispose() {
    _results.removeListener(_onScroll);
    _results.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_results.hasClients) return;
    if (_results.position.pixels >= _results.position.maxScrollExtent - 400) {
      context.read<HomeViewModel>().search.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel vm = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Find a trusted pro',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Book verified handymen near you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSearchField(
                    controller: _search,
                    hintText: 'Search by name or skill',
                    onChanged: vm.onQueryChanged,
                    onClear: () {
                      _search.clear();
                      vm.clearQuery();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: vm.isSearching
                  ? _SearchResults(
                vm: vm.search,
                controller: _results,
              )
                  : const _Categories(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    final CategoriesViewModel vm = context.watch<CategoriesViewModel>();

    if (vm.isLoading || vm.isIdle) {
      return const LoadingView(label: 'Loading categories...');
    }
    if (vm.hasError) {
      return ErrorView(
        message: vm.errorMessage ?? 'Could not load categories.',
        onRetry: vm.load,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        const SectionTitle(title: 'Service categories'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final ServiceCategory category = vm.categories[index];
            return CategoryTile(
              category: category,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProviderListScreen(
                    initialFilter: ProviderFilter(categoryId: category.id),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.vm, required this.controller});

  final ProviderListViewModel vm;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    if (vm.isLoading) {
      return const LoadingView(label: 'Searching...');
    }
    if (vm.hasError) {
      return ErrorView(
        message: vm.errorMessage ?? 'Search failed.',
        onRetry: vm.loadInitial,
      );
    }
    if (vm.isEmpty) {
      return const EmptyView(
        icon: Icons.search_off_rounded,
        title: 'No providers found',
        subtitle: 'Try a different name or skill.',
      );
    }
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        ...vm.providers.map(
              (ServiceProvider provider) => ProviderCard(
            provider: provider,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ProviderDetailScreen(
                  providerId: provider.id,
                  providerName: provider.name,
                ),
              ),
            ),
          ),
        ),
        PaginationFooter(
          isLoadingMore: vm.isLoadingMore,
          hasMore: vm.hasMore,
          errorMessage: vm.loadMoreError,
          onRetry: vm.loadMore,
        ),
      ],
    );
  }
}
