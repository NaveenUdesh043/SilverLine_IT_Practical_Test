import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Theme/CommonVisuals.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Widgets/StarRatings.dart';

import '../../../BaseSDK/Core/Formatters.dart';
import '../../../BaseSDK/Domain/Entities/Review.dart';
import '../../../BaseSDK/Domain/Entities/ServiceProvider.dart';
import '../../../BaseSDK/Domain/UseCases/GetProviderByIdUseCase.dart';
import '../../../BaseSDK/Domain/UseCases/GetProviderReviewsUseCase.dart';
import '../../ViewModel/ProviderDetailViewModel.dart';
import '../Widgets/AvailabilityBadge.dart';
import '../Widgets/EmptyView.dart';
import '../Widgets/ErrorView.dart';
import '../Widgets/LoadingView.dart';
import '../Widgets/ReviewTile.dart';
import '../Widgets/SectionTitle.dart';
import 'BookingScreen.dart';


class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({
    super.key,
    required this.providerId,
    this.providerName,
  });

  final String providerId;
  final String? providerName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderDetailViewModel>(
      create: (context) => ProviderDetailViewModel(
        context.read<GetProviderByIdUseCase>(),
        context.read<GetProviderReviewsUseCase>(),
      )..load(providerId),
      child: _ProviderDetailView(providerId: providerId, name: providerName),
    );
  }
}

class _ProviderDetailView extends StatelessWidget {
  const _ProviderDetailView({required this.providerId, this.name});

  final String providerId;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final ProviderDetailViewModel vm = context.watch<ProviderDetailViewModel>();
    final ServiceProvider? provider = vm.provider;

    return Scaffold(
      appBar: AppBar(title: Text(provider?.name ?? name ?? 'Provider')),
      body: _buildBody(context, vm),
      bottomNavigationBar:
      provider == null || vm.hasError ? null : _BookingBar(vm: vm),
    );
  }

  Widget _buildBody(BuildContext context, ProviderDetailViewModel vm) {
    if (vm.isLoading || vm.isIdle) {
      return const LoadingView(label: 'Loading provider...');
    }
    if (vm.hasError) {
      return ErrorView(
        message: vm.errorMessage ?? 'Could not load provider.',
        onRetry: () => vm.load(providerId),
      );
    }
    final ServiceProvider provider = vm.provider!;
    return RefreshIndicator(
      onRefresh: () => vm.refresh(providerId),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          _Header(provider: provider),
          const SizedBox(height: 20),
          _StatsRow(provider: provider),
          const SizedBox(height: 20),
          const SectionTitle(title: 'About'),
          const SizedBox(height: 8),
          Text(provider.description),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Skills'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.skills
                .map((skill) => Chip(label: Text(skill)))
                .toList(growable: false),
          ),
          const SizedBox(height: 24),
          SectionTitle(
            title: 'Reviews',
            trailing: Text(
              '${vm.reviews.length}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 10),
          if (vm.reviews.isEmpty)
            const EmptyView(
              icon: Icons.rate_review_outlined,
              title: 'No reviews yet',
              subtitle: 'Completed bookings will show reviews here.',
            )
          else
            Column(
              children: vm.reviews
                  .map((Review review) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ReviewTile(review: review),
              ))
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.provider});

  final ServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = CommonVisuals.colorFor(provider.categoryId);
    final String initials = provider.name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((part) => part.isNotEmpty ? part[0] : '')
        .join()
        .toUpperCase();

    return Column(
      children: <Widget>[
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          provider.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          CommonVisuals.nameFor(provider.categoryId),
          style: theme.textTheme.bodyMedium?.copyWith(color: color),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StarRatings(
              rating: provider.rating,
              count: provider.reviewCount,
              size: 18,
            ),
            const SizedBox(width: 12),
            AvailabilityBadge(isAvailable: provider.isAvailable),
          ],
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.provider});

  final ServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _Stat(
          value: '${provider.completedJobs}',
          label: 'Jobs done',
        ),
        _Stat(
          value: '${provider.experienceYears} yr',
          label: 'Experience',
        ),
        _Stat(
          value: Formatters.currency(provider.hourlyRate),
          label: 'Per hour',
        ),
        _Stat(
          value: provider.location,
          label: 'Location',
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.vm});

  final ProviderDetailViewModel vm;

  @override
  Widget build(BuildContext context) {
    final ServiceProvider provider = vm.provider!;
    final bool available = provider.isAvailable;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!available)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'This provider is currently busy. Booking is unavailable.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            FilledButton.icon(
              onPressed: available
                  ? () => Navigator.of(context).push(
                MaterialPageRoute<bool>(
                  builder: (_) => BookingScreen(
                    provider: provider,
                    serviceName:
                    CommonVisuals.nameFor(provider.categoryId),
                  ),
                ),
              )
                  : null,
              icon: const Icon(Icons.event_available_rounded),
              label: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
