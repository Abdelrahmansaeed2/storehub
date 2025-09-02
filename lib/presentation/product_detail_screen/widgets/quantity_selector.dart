import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int>? onQuantityChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.onQuantityChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity =
        widget.initialQuantity.clamp(widget.minQuantity, widget.maxQuantity);
  }

  void _updateQuantity(int newQuantity) {
    final clampedQuantity =
        newQuantity.clamp(widget.minQuantity, widget.maxQuantity);
    if (clampedQuantity != _quantity) {
      setState(() {
        _quantity = clampedQuantity;
      });
      widget.onQuantityChanged?.call(_quantity);
      HapticFeedback.lightImpact();
    }
  }

  void _increment() {
    _updateQuantity(_quantity + 1);
  }

  void _decrement() {
    _updateQuantity(_quantity - 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _quantity > widget.minQuantity ? _decrement : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: _quantity > widget.minQuantity
                      ? Colors.transparent
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'remove',
                    color: _quantity > widget.minQuantity
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Quantity display
          Container(
            width: 16.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border.symmetric(
                vertical: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                _quantity.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Increase button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _quantity < widget.maxQuantity ? _increment : null,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: _quantity < widget.maxQuantity
                      ? Colors.transparent
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: _quantity < widget.maxQuantity
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
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
