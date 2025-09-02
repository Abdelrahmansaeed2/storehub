import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  customerRating,
  newest,
}

class CategorySortBottomSheet extends StatelessWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption> onSortChanged;

  const CategorySortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  static const Map<SortOption, String> _sortLabels = {
    SortOption.featured: 'Featured',
    SortOption.priceLowToHigh: 'Price: Low to High',
    SortOption.priceHighToLow: 'Price: High to Low',
    SortOption.customerRating: 'Customer Rating',
    SortOption.newest: 'Newest',
  };

  static const Map<SortOption, IconData> _sortIcons = {
    SortOption.featured: Icons.star_outline,
    SortOption.priceLowToHigh: Icons.trending_up,
    SortOption.priceHighToLow: Icons.trending_down,
    SortOption.customerRating: Icons.grade,
    SortOption.newest: Icons.schedule,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
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
                  'Sort by',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Sort Options
          ...SortOption.values.map((option) => _buildSortOption(
                context,
                option,
                _sortLabels[option]!,
                _sortIcons[option]!,
              )),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    SortOption option,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = option == selectedSort;

    return InkWell(
      onTap: () {
        onSortChanged(option);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 2.h,
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon.codePoint.toString(),
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
