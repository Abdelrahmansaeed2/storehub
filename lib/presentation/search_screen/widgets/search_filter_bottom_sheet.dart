import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final double minPrice;
  final double maxPrice;
  final double selectedMinPrice;
  final double selectedMaxPrice;
  final double minRating;
  final double selectedMinRating;
  final ValueChanged<List<String>>? onCategoriesChanged;
  final ValueChanged<RangeValues>? onPriceRangeChanged;
  final ValueChanged<double>? onRatingChanged;
  final VoidCallback? onClearAll;
  final VoidCallback? onApply;

  const SearchFilterBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.minPrice,
    required this.maxPrice,
    required this.selectedMinPrice,
    required this.selectedMaxPrice,
    required this.minRating,
    required this.selectedMinRating,
    this.onCategoriesChanged,
    this.onPriceRangeChanged,
    this.onRatingChanged,
    this.onClearAll,
    this.onApply,
  });

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late List<String> _selectedCategories;
  late RangeValues _priceRange;
  late double _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
    _priceRange = RangeValues(widget.selectedMinPrice, widget.selectedMaxPrice);
    _selectedRating = widget.selectedMinRating;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.5.h),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter & Sort',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategories.clear();
                      _priceRange =
                          RangeValues(widget.minPrice, widget.maxPrice);
                      _selectedRating = widget.minRating;
                    });
                    widget.onClearAll?.call();
                  },
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  // Categories Section
                  Text(
                    'Categories',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: widget.categories.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                        backgroundColor: colorScheme.surface,
                        selectedColor:
                            colorScheme.primary.withValues(alpha: 0.1),
                        checkmarkColor: colorScheme.primary,
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),
                  // Price Range Section
                  Text(
                    'Price Range',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_priceRange.start.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '\$${_priceRange.end.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: widget.minPrice,
                    max: widget.maxPrice,
                    divisions: 20,
                    activeColor: colorScheme.primary,
                    inactiveColor: colorScheme.outline.withValues(alpha: 0.3),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  // Rating Section
                  Text(
                    'Minimum Rating',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _selectedRating,
                          min: widget.minRating,
                          max: 5.0,
                          divisions: 8,
                          activeColor: colorScheme.primary,
                          inactiveColor:
                              colorScheme.outline.withValues(alpha: 0.3),
                          onChanged: (value) {
                            setState(() {
                              _selectedRating = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _selectedRating.toStringAsFixed(1),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onCategoriesChanged?.call(_selectedCategories);
                    widget.onPriceRangeChanged?.call(_priceRange);
                    widget.onRatingChanged?.call(_selectedRating);
                    widget.onApply?.call();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
