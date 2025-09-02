import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/category_empty_state.dart';
import './widgets/category_loading_grid.dart';
import './widgets/category_product_card.dart';
import './widgets/category_sort_bottom_sheet.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Dio _dio = Dio();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _categoryName = 'All Products';
  bool _isLoading = true;
  bool _hasError = false;
  SortOption _selectedSort = SortOption.featured;
  int _currentBottomIndex = 2; // Categories tab active

  // Mock categories for fallback
  final List<String> _categories = [
    'electronics',
    'jewelery',
    'men\'s clothing',
    'women\'s clothing',
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeScreen() {
    // Get category from route arguments or use default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['category'] != null) {
        _categoryName = args['category'] as String;
      }
      _loadCategoryProducts();
    });
  }

  void _onScroll() {
    // Implement infinite scroll if needed
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more products
    }
  }

  Future<void> _loadCategoryProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _showOfflineData();
        return;
      }

      String apiUrl = 'https://fakestoreapi.com/products';
      if (_categoryName != 'All Products') {
        apiUrl += '/category/${_categoryName.toLowerCase()}';
      }

      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _products = data.map((item) => item as Map<String, dynamic>).toList();
          _filteredProducts = List.from(_products);
          _isLoading = false;
        });
        _applySorting();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _showOfflineData();
    }
  }

  void _showOfflineData() {
    // Show cached/mock data when offline
    final mockProducts = _getMockProducts();
    setState(() {
      _products = mockProducts;
      _filteredProducts = List.from(_products);
      _isLoading = false;
      _hasError = false;
    });

    Fluttertoast.showToast(
      msg: "Showing cached data - Check your connection",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  List<Map<String, dynamic>> _getMockProducts() {
    return [
      {
        "id": 1,
        "title": "Premium Wireless Headphones",
        "price": 299.99,
        "description":
            "High-quality wireless headphones with noise cancellation and premium sound quality.",
        "category": _categoryName.toLowerCase(),
        "image":
            "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop",
        "rating": {"rate": 4.5, "count": 120}
      },
      {
        "id": 2,
        "title": "Smart Fitness Watch",
        "price": 199.99,
        "description":
            "Advanced fitness tracking with heart rate monitoring and GPS functionality.",
        "category": _categoryName.toLowerCase(),
        "image":
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop",
        "rating": {"rate": 4.2, "count": 89}
      },
      {
        "id": 3,
        "title": "Portable Bluetooth Speaker",
        "price": 79.99,
        "description":
            "Compact wireless speaker with powerful bass and long battery life.",
        "category": _categoryName.toLowerCase(),
        "image":
            "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500&h=500&fit=crop",
        "rating": {"rate": 4.7, "count": 156}
      },
      {
        "id": 4,
        "title": "Wireless Charging Pad",
        "price": 49.99,
        "description":
            "Fast wireless charging pad compatible with all Qi-enabled devices.",
        "category": _categoryName.toLowerCase(),
        "image":
            "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500&h=500&fit=crop",
        "rating": {"rate": 4.0, "count": 67}
      },
      {
        "id": 5,
        "title": "USB-C Hub Adapter",
        "price": 89.99,
        "description":
            "Multi-port USB-C hub with HDMI, USB 3.0, and SD card reader.",
        "category": _categoryName.toLowerCase(),
        "image":
            "https://images.unsplash.com/photo-1625842268584-8f3296236761?w=500&h=500&fit=crop",
        "rating": {"rate": 4.3, "count": 94}
      },
      {
        "id": 6,
        "title": "Mechanical Gaming Keyboard",
        "price": 159.99,
        "description":
            "RGB backlit mechanical keyboard with customizable keys and gaming features.",
        "category": _categoryName.toLowerCase(),
        "image":
            "https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=500&h=500&fit=crop",
        "rating": {"rate": 4.6, "count": 203}
      },
    ];
  }

  void _applySorting() {
    setState(() {
      switch (_selectedSort) {
        case SortOption.featured:
          _filteredProducts.sort((a, b) => (b['rating']['rate'] as num)
              .compareTo(a['rating']['rate'] as num));
          break;
        case SortOption.priceLowToHigh:
          _filteredProducts
              .sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
          break;
        case SortOption.priceHighToLow:
          _filteredProducts
              .sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
          break;
        case SortOption.customerRating:
          _filteredProducts.sort((a, b) => (b['rating']['rate'] as num)
              .compareTo(a['rating']['rate'] as num));
          break;
        case SortOption.newest:
          _filteredProducts
              .sort((a, b) => (b['id'] as num).compareTo(a['id'] as num));
          break;
      }
    });
  }

  void _showSortBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySortBottomSheet(
        selectedSort: _selectedSort,
        onSortChanged: (sortOption) {
          setState(() {
            _selectedSort = sortOption;
          });
          _applySorting();
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await _loadCategoryProducts();
  }

  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail-screen',
      arguments: {'product': product},
    );
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-screen',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.detail,
        title: _categoryName,
        showBackButton: false,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: _showSortBottomSheet,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Sort products',
          ),
        ],
      ),
      body: Column(
        children: [
          // Product Count Indicator
          if (!_isLoading && !_hasError) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                '${_filteredProducts.length} products found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          // Main Content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const CategoryLoadingGrid();
    }

    if (_hasError && _products.isEmpty) {
      return _buildErrorState();
    }

    if (_filteredProducts.isEmpty) {
      return CategoryEmptyState(
        categoryName: _categoryName,
        onBrowseOtherCategories: _navigateToHome,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return CategoryProductCard(
            product: product,
            onTap: () => _navigateToProductDetail(product),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: colorScheme.error,
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Unable to load products. Please check your connection and try again.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loadCategoryProducts,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(
                  'Try Again',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
