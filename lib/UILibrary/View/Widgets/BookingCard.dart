import 'package:flutter/material.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Theme/CommonVisuals.dart';

import '../../../BaseSDK/Core/Formatters.dart';
import '../../../BaseSDK/Domain/Entities/Booking.dart';
import 'StatusWidget.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.actions = const <Widget>[],
  });

  final Booking booking;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = CommonVisuals.colorFor(booking.categoryId);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CommonVisuals.iconFor(booking.categoryId),
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        booking.providerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        booking.serviceName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusWidget(status: booking.status),
              ],
            ),
            const SizedBox(height: 14),
            _Row(
              icon: Icons.calendar_today_rounded,
              text: Formatters.date(booking.date),
            ),
            const SizedBox(height: 6),
            _Row(icon: Icons.schedule_rounded, text: booking.timeSlot),
            const SizedBox(height: 6),
            _Row(icon: Icons.location_on_outlined, text: booking.address),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Text(
                  '${booking.hours} hr${booking.hours > 1 ? 's' : ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  Formatters.currency(booking.totalCost),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (actions.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
