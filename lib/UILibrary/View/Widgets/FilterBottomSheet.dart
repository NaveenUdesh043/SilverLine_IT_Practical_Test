
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Theme/CommonVisuals.dart';

import '../../../BaseSDK/Core/AppConstants.dart';
import '../../../BaseSDK/Domain/CommonObjets/ProviderFilter.dart';
import '../../../BaseSDK/Domain/CommonObjets/ProviderSort.dart';
import '../../../BaseSDK/Domain/Entities/ServiceCategory.dart';

Future<ProviderSort?> showSortSheet(
    BuildContext context, {
      required ProviderSort current,
    }) {
  return showModalBottomSheet<ProviderSort>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sort by',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          RadioGroup<ProviderSort>(
            groupValue: current,
            onChanged: (value) => Navigator.of(context).pop(value),
            child: Column(
              children: ProviderSort.values
                  .map(
                    (sort) => RadioListTile<ProviderSort>(
                  value: sort,
                  title: Text(sort.label),
                ),
              )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Future<ProviderFilter?> showFilterSheet(
    BuildContext context, {
      required ProviderFilter current,
      required List<ServiceCategory> categories,
    }) {
  return showModalBottomSheet<ProviderFilter>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _FilterSheet(
      current: current,
      categories: categories,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.current, required this.categories});

  final ProviderFilter current;
  final List<ServiceCategory> categories;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _categoryId = widget.current.categoryId;
  late double? _minRating = widget.current.minRating;
  late RangeValues _rateRange = RangeValues(
    widget.current.resolvedMinRate,
    widget.current.resolvedMaxRate,
  );
  late bool _availableOnly = widget.current.availableOnly;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: <Widget>[
                  Text(
                    'Filters',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearAll,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  _label('Category'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _categoryChip(null, 'All'),
                      ...widget.categories.map(
                            (category) => _categoryChip(category.id, category.name),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('Minimum rating'),
                  Wrap(
                    spacing: 8,
                    children: <Widget>[
                      _ratingChip(null, 'Any'),
                      ...AppConstants.ratingFilterOptions.map(
                            (value) => _ratingChip(
                          value,
                          '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}+',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('Hourly rate (LKR)'),
                  Text(
                    '${_rateRange.start.round()} - ${_rateRange.end.round()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  RangeSlider(
                    values: _rateRange,
                    min: AppConstants.minHourlyRate,
                    max: AppConstants.maxHourlyRate,
                    divisions: 30,
                    labels: RangeLabels(
                      _rateRange.start.round().toString(),
                      _rateRange.end.round().toString(),
                    ),
                    onChanged: (values) => setState(() => _rateRange = values),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _availableOnly,
                    onChanged: (value) =>
                        setState(() => _availableOnly = value),
                    title: const Text('Available providers only'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: FilledButton(
                onPressed: _apply,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    ),
  );

  Widget _categoryChip(String? id, String name) {
    final bool selected = _categoryId == id;
    return ChoiceChip(
      selected: selected,
      label: Text(name),
      avatar: id == null
          ? null
          : Icon(
        CommonVisuals.iconFor(id),
        size: 16,
        color: selected ? null : CommonVisuals.colorFor(id),
      ),
      onSelected: (_) => setState(() => _categoryId = id),
    );
  }

  Widget _ratingChip(double? value, String label) {
    final bool selected = _minRating == value;
    return ChoiceChip(
      selected: selected,
      label: Text(label),
      avatar: value == null
          ? null
          : const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF5A524)),
      onSelected: (_) => setState(() => _minRating = value),
    );
  }

  void _clearAll() {
    setState(() {
      _categoryId = null;
      _minRating = null;
      _rateRange = const RangeValues(
        AppConstants.minHourlyRate,
        AppConstants.maxHourlyRate,
      );
      _availableOnly = false;
    });
  }

  void _apply() {
    final bool fullRange = _rateRange.start <= AppConstants.minHourlyRate &&
        _rateRange.end >= AppConstants.maxHourlyRate;
    Navigator.of(context).pop(
      ProviderFilter(
        categoryId: _categoryId,
        minRating: _minRating,
        minHourlyRate: fullRange ? null : _rateRange.start,
        maxHourlyRate: fullRange ? null : _rateRange.end,
        availableOnly: _availableOnly,
        query: widget.current.query,
      ),
    );
  }
}
