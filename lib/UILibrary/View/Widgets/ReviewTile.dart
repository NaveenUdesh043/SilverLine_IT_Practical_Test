import 'package:flutter/material.dart';

import '../../../BaseSDK/Core/Formatters.dart';
import '../../../BaseSDK/Domain/Entities/Review.dart';


class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundColor:
                theme.colorScheme.primary.withValues(alpha: 0.15),
                child: Text(
                  review.authorName.isNotEmpty
                      ? review.authorName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      review.authorName,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      Formatters.date(review.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _Stars(rating: review.rating),
            ],
          ),
          if (review.comment.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(review.comment, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        final bool filled = index < rating.round();
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: const Color(0xFFF5A524),
        );
      }),
    );
  }
}
