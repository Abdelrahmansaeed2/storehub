import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProductInfoSection extends StatelessWidget {
  final String title;
  final double price;
  final double rating;
  final int ratingCount;
  final String category;
  final VoidCallback? onCategoryTap;

  const ProductInfoSection({
    super.key,
    required this.title,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.category,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Price
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
              letterSpacing: -0.02,
            ),
          ),

          SizedBox(height: 2.h),

          // Rating and reviews
          Row(
            children: [
              // Star rating
              Row(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 0.5.w),
                    child: CustomIconWidget(
                      iconName: index < rating.floor()
                          ? 'star'
                          : index < rating
                              ? 'star_half'
                              : 'star_border',
                      color: index < rating
                          ? Colors.amber
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      size: 18,
                    ),
                  );
                }),
              ),

              SizedBox(width: 2.w),

              // Rating value and count
              Text(
                '${rating.toStringAsFixed(1)} (${ratingCount} reviews)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Category chip
          GestureDetector(
            onTap: onCategoryTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'category',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    category.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: colorScheme.primary,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
