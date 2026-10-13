import 'package:flutter/material.dart';


class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.status});

  final BookingStatus status;

  static const Map<BookingStatus, Color> _colors = <BookingStatus, Color>{
    BookingStatus.pending: Color(0xFFE8892B),
    BookingStatus.confirmed: Color(0xFF2F6FED),
    BookingStatus.inProgress: Color(0xFF0EA5A5),
    BookingStatus.completed: Color(0xFF22A06B),
    BookingStatus.cancelled: Color(0xFF7A8699),
    BookingStatus.rejected: Color(0xFFE5484D),
  };

  @override
  Widget build(BuildContext context) {
    final Color color = _colors[status] ?? const Color(0xFF7A8699);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
