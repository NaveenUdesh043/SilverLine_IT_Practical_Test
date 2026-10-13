import 'package:flutter/material.dart';

class StarRatings extends StatelessWidget {
  const StarRatings({
    super.key,
    required this.rating,
    this.size = 16,
    this.count,
    this.showCount = true,
  });

  final double rating;
  final double size;
  final int? count;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.star_rounded, size: size, color: const Color(0xFFF5A524)),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size * 0.85, fontWeight: FontWeight.w700),
        ),
        if (showCount && count != null) ...<Widget>[
          const SizedBox(width: 3),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: size * 0.8,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
