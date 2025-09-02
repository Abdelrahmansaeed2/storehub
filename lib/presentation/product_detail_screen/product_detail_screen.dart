import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/expandable_description.dart';
import './widgets/product_image_carousel.dart';
import './widgets/product_info_section.dart';
import './widgets/sticky_bottom_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = true;

  // Mock product data - in real app this would come from API/navigation arguments
  final Map<String, dynamic> productData = {
    "id": 1,
    "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    "price": 109.95,
    "description":
        "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday essentials in the main compartment, and your phone and wallet in the front zippered pocket. The shoulder straps are adjustable and the back panel is padded for comfort. Made from durable water-resistant fabric that will keep your belongings dry in light rain.",
    "category": "men's clothing",
    "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
    "rating": {"rate": 3.9, "count": 120}
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Hide/show sticky bar based on scroll direction
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showStickyBar) {
        setState(() {
          _showStickyBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showStickyBar) {
        setState(() {
          _showStickyBar = true;
        });
      }
    }
  }

  void _handleShare() {
    HapticFeedback.lightImpact();
    // In real app, implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleFavorite() {
    HapticFeedback.lightImpact();
    // In real app, implement favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favorites'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleCategoryTap() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/category-screen');
  }

  void _handleAddToCart() {
    // Handled in StickyBottomBar widget
  }

  void _handleBuyNow() {
    HapticFeedback.mediumImpact();
    // In real app, navigate to checkout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proceeding to checkout...'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final rating = (productData["rating"] as Map<String, dynamic>);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
        leading: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios_new',
              color: colorScheme.onSurface,
              size: 20,
            ),
            tooltip: 'Back',
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _handleFavorite,
              icon: CustomIconWidget(
                iconName: 'favorite_border',
                color: colorScheme.onSurface,
                size: 20,
              ),
              tooltip: 'Add to favorites',
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 4.w, top: 2.w, bottom: 2.w),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _handleShare,
              icon: CustomIconWidget(
                iconName: 'share',
                color: colorScheme.onSurface,
                size: 20,
              ),
              tooltip: 'Share',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Product image carousel
              SliverToBoxAdapter(
                child: ProductImageCarousel(
                  imageUrl: productData["image"] as String,
                  productTitle: productData["title"] as String,
                ),
              ),

              // Product information
              SliverToBoxAdapter(
                child: ProductInfoSection(
                  title: productData["title"] as String,
                  price: (productData["price"] as num).toDouble(),
                  rating: (rating["rate"] as num).toDouble(),
                  ratingCount: rating["count"] as int,
                  category: productData["category"] as String,
                  onCategoryTap: _handleCategoryTap,
                ),
              ),

              // Description section
              SliverToBoxAdapter(
                child: ExpandableDescription(
                  description: productData["description"] as String,
                ),
              ),

              // Additional product details
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Product Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      _buildDetailRow(
                          context, 'Product ID', '#${productData["id"]}'),
                      _buildDetailRow(context, 'Category',
                          productData["category"] as String),
                      _buildDetailRow(context, 'Rating',
                          '${rating["rate"]}/5.0 (${rating["count"]} reviews)'),
                      _buildDetailRow(context, 'Availability', 'In Stock'),
                      _buildDetailRow(context, 'Shipping',
                          'Free shipping on orders over \$50'),
                    ],
                  ),
                ),
              ),

              // Bottom spacing for sticky bar
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
            ],
          ),

          // Sticky bottom bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showStickyBar ? 0 : -25.h,
            left: 0,
            right: 0,
            child: StickyBottomBar(
              price: (productData["price"] as num).toDouble(),
              onAddToCart: _handleAddToCart,
              onBuyNow: _handleBuyNow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}