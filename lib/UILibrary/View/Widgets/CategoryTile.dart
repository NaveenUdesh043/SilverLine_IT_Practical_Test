import 'package:flutter/material.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Theme/CommonVisuals.dart';

import '../../../BaseSDK/Domain/Entities/ServiceCategory.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, this.onTap});

  final ServiceCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = CommonVisuals.colorFor(category.id);

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  CommonVisuals.iconFor(category.id),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
