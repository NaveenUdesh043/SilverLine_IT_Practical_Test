import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyBookingsViewModel>(
      create: (context) => MyBookingsViewModel(
        context.read<GetBookingsUseCase>(),
        context.read<CancelBookingUseCase>(),
        context.read<AddReviewUseCase>(),
      )..load(),
      child: const _MyBookingsView(),
    );
  }
}

class _MyBookingsView extends StatelessWidget {
  const _MyBookingsView();

  @override
  Widget build(BuildContext context) {
    final MyBookingsViewModel vm = context.watch<MyBookingsViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Upcoming'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyBookingsViewModel vm) {
    if (vm.isLoading || vm.isIdle) {
      return const LoadingView(label: 'Loading bookings...');
    }
    if (vm.hasError) {
      return ErrorView(
        message: vm.errorMessage ?? 'Could not load bookings.',
        onRetry: vm.load,
      );
    }
    return TabBarView(
      children: <Widget>[
        _BookingList(
          bookings: vm.upcoming,
          vm: vm,
          isUpcoming: true,
          emptyTitle: 'No upcoming bookings',
          emptySubtitle: 'Book a provider from the Home tab.',
        ),
        _BookingList(
          bookings: vm.history,
          vm: vm,
          isUpcoming: false,
          emptyTitle: 'No past bookings',
          emptySubtitle: 'Your completed and cancelled jobs appear here.',
        ),
      ],
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.bookings,
    required this.vm,
    required this.isUpcoming,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final List<Booking> bookings;
  final MyBookingsViewModel vm;
  final bool isUpcoming;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: <Widget>[
          if (bookings.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: EmptyView(
                icon: Icons.event_busy_rounded,
                title: emptyTitle,
                subtitle: emptySubtitle,
              ),
            )
          else
            ...bookings.map(
                  (booking) => BookingCard(
                booking: booking,
                actions: _actionsFor(context, booking),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _actionsFor(BuildContext context, Booking booking) {
    final List<Widget> actions = <Widget>[];

    if (isUpcoming && vm.canCancel(booking)) {
      actions.add(
        OutlinedButton.icon(
          onPressed: vm.isMutating ? null : () => _confirmCancel(context, booking),
          icon: const Icon(Icons.cancel_outlined, size: 18),
          label: const Text('Cancel'),
        ),
      );
    }

    if (!isUpcoming &&
        booking.status == BookingStatus.completed &&
        !booking.reviewed) {
      actions.add(
        FilledButton.tonalIcon(
          onPressed: vm.isMutating ? null : () => _rate(context, booking),
          icon: const Icon(Icons.star_rounded, size: 18),
          label: const Text('Rate'),
        ),
      );
    }

    return actions;
  }

  Future<void> _confirmCancel(BuildContext context, Booking booking) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text(
          'Cancel your booking with ${booking.providerName}? This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final String? error = await vm.cancel(booking.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Booking cancelled.'),
      ),
    );
  }

  Future<void> _rate(BuildContext context, Booking booking) async {
    final RateResult? result =
    await showRateDialog(context, providerName: booking.providerName);
    if (result == null || !context.mounted) return;

    final String? error = await vm.submitReview(
      bookingId: booking.id,
      providerId: booking.providerId,
      rating: result.rating,
      comment: result.comment,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Thanks! Your review was added.'),
      ),
    );
  }
}
