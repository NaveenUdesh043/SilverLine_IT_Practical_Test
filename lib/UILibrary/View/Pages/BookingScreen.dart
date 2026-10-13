import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({
    super.key,
    required this.provider,
    required this.serviceName,
  });

  final ServiceProvider provider;
  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingViewModel>(
      create: (context) =>
          BookingViewModel(context.read<CreateBookingUseCase>()),
      child: _BookingView(provider: provider, serviceName: serviceName),
    );
  }
}

class _BookingView extends StatefulWidget {
  const _BookingView({required this.provider, required this.serviceName});

  final ServiceProvider provider;
  final String serviceName;

  @override
  State<_BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<_BookingView> {
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  @override
  void dispose() {
    _address.dispose();
    _phone.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BookingViewModel vm = context.watch<BookingViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Book Service')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          _ProviderSummary(
            provider: widget.provider,
            serviceName: widget.serviceName,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _address,
            onChanged: vm.setAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Service address',
              hintText: 'House no, street, city',
              prefixIcon: const Icon(Icons.location_on_outlined),
              errorText: vm.errorFor('address'),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phone,
            onChanged: vm.setPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Contact number',
              hintText: '07XXXXXXXX',
              prefixIcon: const Icon(Icons.phone_outlined),
              errorText: vm.errorFor('phone'),
            ),
          ),
          const SizedBox(height: 16),
          _DateField(vm: vm),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: vm.timeSlot,
            items: AppConstants.timeSlots
                .map((slot) => DropdownMenuItem<String>(
              value: slot,
              child: Text(slot),
            ))
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) vm.setTimeSlot(value);
            },
            decoration: InputDecoration(
              labelText: 'Time slot',
              prefixIcon: const Icon(Icons.schedule_rounded),
              errorText: vm.errorFor('timeSlot'),
            ),
          ),
          const SizedBox(height: 16),
          _HoursField(vm: vm),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notes,
            onChanged: vm.setNotes,
            maxLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'Describe the problem...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          _TotalCard(
            label: 'Estimated total',
            value: Formatters.currency(vm.totalCost(widget.provider)),
            caption:
            '${Formatters.currency(widget.provider.hourlyRate)}/hr x ${vm.hours} hr',
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: vm.isLoading
                ? null
                : () => _submit(context, vm),
            child: vm.isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
                : const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, BookingViewModel vm) async {
    final Booking? booking = await vm.submit(
      provider: widget.provider,
      serviceName: widget.serviceName,
      now: DateTime.now(),
    );
    if (!mounted || !context.mounted) return;

    if (booking != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed. Check My Bookings.')),
      );
      Navigator.of(context).pop(true);
    } else if (vm.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Booking failed.')),
      );
    }
  }
}

class _ProviderSummary extends StatelessWidget {
  const _ProviderSummary({required this.provider, required this.serviceName});

  final ServiceProvider provider;
  final String serviceName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.handyman_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  provider.name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '$serviceName - ${provider.location}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.vm});

  final BookingViewModel vm;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final DateTime now = DateTime.now();
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: vm.date ?? now.add(const Duration(days: 1)),
          firstDate: now,
          lastDate: now.add(const Duration(days: 60)),
        );
        if (picked != null) vm.setDate(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Preferred date',
          prefixIcon: const Icon(Icons.calendar_today_rounded),
          errorText: vm.errorFor('date'),
        ),
        child: Text(
          vm.date == null ? 'Select a date' : Formatters.date(vm.date!),
        ),
      ),
    );
  }
}

class _HoursField extends StatelessWidget {
  const _HoursField({required this.vm});

  final BookingViewModel vm;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Estimated hours',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            IconButton.filledTonal(
              onPressed: vm.hours > vm.minHours
                  ? () => vm.setHours(vm.hours - 1)
                  : null,
              icon: const Icon(Icons.remove_rounded),
            ),
            const SizedBox(width: 12),
            Text(
              '${vm.hours}',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              onPressed: vm.hours < vm.maxHours
                  ? () => vm.setHours(vm.hours + 1)
                  : null,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        if (vm.errorFor('hours') != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              vm.errorFor('hours')!,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: theme.textTheme.bodyMedium),
              Text(
                caption,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
