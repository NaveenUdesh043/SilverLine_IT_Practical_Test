import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../BaseSDK/Domain/Entities/Booking.dart';
import '../../../BaseSDK/Domain/Entities/BookingStatus.dart';
import '../../../BaseSDK/Domain/UseCases/GetBookingsUseCase.dart';
import '../../../BaseSDK/Domain/UseCases/UpdateBookingStatusUseCase.dart';
import '../../ViewModel/ProviderJobsViewModel.dart';
import '../Widgets/BookingCard.dart';
import '../Widgets/EmptyView.dart';
import '../Widgets/ErrorView.dart';
import '../Widgets/LoadingView.dart';


class ProviderJobsScreen extends StatelessWidget {
  const ProviderJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderJobsViewModel>(
      create: (context) => ProviderJobsViewModel(
        context.read<GetBookingsUseCase>(),
        context.read<UpdateBookingStatusUseCase>(),
      )..load(),
      child: const _ProviderJobsView(),
    );
  }
}

class _ProviderJobsView extends StatelessWidget {
  const _ProviderJobsView();

  @override
  Widget build(BuildContext context) {
    final ProviderJobsViewModel vm = context.watch<ProviderJobsViewModel>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jobs'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'New'),
              Tab(text: 'Active'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProviderJobsViewModel vm) {
    if (vm.isLoading || vm.isIdle) {
      return const LoadingView(label: 'Loading jobs...');
    }
    if (vm.hasError) {
      return ErrorView(
        message: vm.errorMessage ?? 'Could not load jobs.',
        onRetry: vm.load,
      );
    }
    return TabBarView(
      children: <Widget>[
        _JobList(
          jobs: vm.newRequests,
          vm: vm,
          emptyTitle: 'No new requests',
        ),
        _JobList(
          jobs: vm.active,
          vm: vm,
          emptyTitle: 'No active jobs',
        ),
        _JobList(
          jobs: vm.finished,
          vm: vm,
          emptyTitle: 'No completed jobs',
        ),
      ],
    );
  }
}

class _JobList extends StatelessWidget {
  const _JobList({
    required this.jobs,
    required this.vm,
    required this.emptyTitle,
  });

  final List<Booking> jobs;
  final ProviderJobsViewModel vm;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: <Widget>[
          if (jobs.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: EmptyView(
                icon: Icons.work_off_rounded,
                title: emptyTitle,
              ),
            )
          else
            ...jobs.map(
                  (job) => BookingCard(
                booking: job,
                actions: _actionsFor(context, job),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _actionsFor(BuildContext context, Booking job) {
    final bool busy = vm.isMutating;
    switch (job.status) {
      case BookingStatus.pending:
        return <Widget>[
          OutlinedButton(
            onPressed: busy
                ? null
                : () => _update(context, job.id, BookingStatus.rejected),
            child: const Text('Reject'),
          ),
          FilledButton(
            onPressed: busy
                ? null
                : () => _update(context, job.id, BookingStatus.confirmed),
            child: const Text('Accept'),
          ),
        ];
      case BookingStatus.confirmed:
        return <Widget>[
          FilledButton.tonal(
            onPressed: busy
                ? null
                : () => _update(context, job.id, BookingStatus.inProgress),
            child: const Text('Start Job'),
          ),
        ];
      case BookingStatus.inProgress:
        return <Widget>[
          FilledButton.tonal(
            onPressed: busy
                ? null
                : () => _update(context, job.id, BookingStatus.completed),
            child: const Text('Mark Complete'),
          ),
        ];
      case BookingStatus.completed:
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
        return const <Widget>[];
    }
  }

  Future<void> _update(
      BuildContext context,
      String bookingId,
      BookingStatus status,
      ) async {
    final String? error = await vm.updateStatus(bookingId, status);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Job updated to ${status.label}.')),
    );
  }
}
