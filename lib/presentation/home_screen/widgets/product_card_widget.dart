import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../domain/entities/product.dart'; // Entity import

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image takes available vertical space
            Expanded(child: _buildProductImage(colorScheme)),

            // Product details section
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTitle(theme),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProductPrice(theme, colorScheme),
                      _buildProductRating(theme, colorScheme),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the product image with fixed height
  Widget _buildProductImage(ColorScheme colorScheme) {
    return Container(
      height: 20.h, // Fixed height to prevent overflow
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: CustomImageWidget(
          imageUrl: product.image ?? "",
          width: double.infinity,
          height: 20.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Builds the product title with max 2 lines
  Widget _buildProductTitle(ThemeData theme) {
    return Text(
      product.title ?? "Product Title",
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the product price
  Widget _buildProductPrice(ThemeData theme, ColorScheme colorScheme) {
    final price = product.price;
    final formattedPrice =
    price != null ? "\$${price.toStringAsFixed(2)}" : "\$0.00";

    return Text(
      formattedPrice,
      style: theme.textTheme.titleSmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Builds the product rating with star icon
  Widget _buildProductRating(ThemeData theme, ColorScheme colorScheme) {
    final ratingValue = product.rating?.rate ?? 0.0;
    final ratingCount = product.rating?.count ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomIconWidget(
          iconName: 'star',
          color: Color(0xFFF59E0B),
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          ratingValue.toStringAsFixed(1),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          "($ratingCount)",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
