import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomAppBarVariant {
  standard,
  search,
  detail,
  minimal,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomAppBarVariant variant;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final VoidCallback? onSearchTap;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final String? searchHint;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.standard,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onSearchTap,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint = 'Search products...',
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: _buildTitle(context),
      actions: _buildActions(context),
      centerTitle: variant == CustomAppBarVariant.minimal,
      titleSpacing: variant == CustomAppBarVariant.search ? 0 : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton ||
        (automaticallyImplyLeading && Navigator.canPop(context))) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        tooltip: 'Back',
      );
    }

    return null;
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.detail:
      case CustomAppBarVariant.minimal:
        return title != null
            ? Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.02,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null;

      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted:
                onSearchSubmitted != null ? (_) => onSearchSubmitted!() : null,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: searchController?.text.isNotEmpty == true
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        searchController?.clear();
                        onSearchChanged?.call('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            style: theme.textTheme.bodyMedium,
            textInputAction: TextInputAction.search,
          ),
        );
    }
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final defaultActions = <Widget>[];

    // Add search action for non-search variants
    if (variant != CustomAppBarVariant.search && onSearchTap != null) {
      defaultActions.add(
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: () {
            onSearchTap?.call();
            Navigator.pushNamed(context, '/search-screen');
          },
          tooltip: 'Search',
        ),
      );
    }

    // Add variant-specific actions
    switch (variant) {
      case CustomAppBarVariant.standard:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 24),
            onPressed: () {
              // Navigate to favorites or wishlist
            },
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 24),
            onPressed: () {
              // Navigate to cart
            },
            tooltip: 'Cart',
          ),
        ]);
        break;

      case CustomAppBarVariant.detail:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 24),
            onPressed: () {
              // Add to favorites
            },
            tooltip: 'Add to favorites',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 24),
            onPressed: () {
              // Share product
            },
            tooltip: 'Share',
          ),
        ]);
        break;

      case CustomAppBarVariant.search:
        defaultActions.add(
          IconButton(
            icon: const Icon(Icons.tune, size: 24),
            onPressed: () {
              // Show filter bottom sheet
              _showFilterBottomSheet(context);
            },
            tooltip: 'Filter',
          ),
        );
        break;

      case CustomAppBarVariant.minimal:
        // No default actions for minimal variant
        break;
    }

    // Combine with custom actions
    final allActions = <Widget>[...defaultActions, ...(actions ?? [])];
    return allActions.isNotEmpty ? allActions : null;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Filter options will be implemented here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}