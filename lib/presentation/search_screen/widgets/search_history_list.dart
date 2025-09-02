import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHistoryList extends StatelessWidget {
  final List<String> searchHistory;
  final ValueChanged<String>? onHistoryTap;
  final ValueChanged<String>? onHistoryRemove;
  final VoidCallback? onClearAll;

  const SearchHistoryList({
    super.key,
    required this.searchHistory,
    this.onHistoryTap,
    this.onHistoryRemove,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (searchHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (onClearAll != null)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchHistory.length > 8 ? 8 : searchHistory.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
            indent: 4.w,
            endIndent: 4.w,
          ),
          itemBuilder: (context, index) {
            final query = searchHistory[index];
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              leading: CustomIconWidget(
                iconName: 'history',
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              title: Text(
                query,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: onHistoryRemove != null
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => onHistoryRemove?.call(query),
                      visualDensity: VisualDensity.compact,
                    )
                  : CustomIconWidget(
                      iconName: 'north_west',
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
              onTap: () => onHistoryTap?.call(query),
            );
          },
        ),
      ],
    );
  }
}
