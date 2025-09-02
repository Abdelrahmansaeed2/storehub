import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/di/dependency_injection.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../bloc/categories/categories_bloc.dart';
import '../bloc/products/products_bloc.dart';
import './widgets/category_chips_widget.dart';
import './widgets/featured_carousel_widget.dart';
import './widgets/product_grid_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>(
          create: (context) =>
              DependencyInjection.createProductsBloc()..add(LoadAllProducts()),
        ),
        BlocProvider<CategoriesBloc>(
          create: (context) =>
              DependencyInjection.createCategoriesBloc()..add(LoadCategories()),
        ),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header with Search Bar
            Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  SearchBarWidget(
                    onTap: () => _onSearchTap(context),
                    hintText: 'Search products...',
                  ),
                  BlocListener<ProductsBloc, ProductsState>(
                    listener: (context, state) {
                      if (state is ProductsError) {
                        _showToast(state.message);
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Featured Carousel
                  const SliverToBoxAdapter(
                    child: FeaturedCarouselWidget(),
                  ),

                  // Category Chips
                  SliverToBoxAdapter(
                    child: BlocBuilder<CategoriesBloc, CategoriesState>(
                      builder: (context, state) {
                        if (state is CategoriesLoaded) {
                          return CategoryChipsWidget(
                            categories: state.categories,
                            onCategorySelected: (category) =>
                                _onCategorySelected(context, category),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // Products Section Header
                  SliverToBoxAdapter(
                    child: BlocBuilder<ProductsBloc, ProductsState>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state is ProductsLoaded &&
                                        state.selectedCategory != null
                                    ? "${state.selectedCategory!.toUpperCase()} PRODUCTS"
                                    : "ALL PRODUCTS",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (state is ProductsLoaded)
                                Text(
                                  "${state.products.length} items",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Product Grid
                  SliverFillRemaining(
                    child: BlocBuilder<ProductsBloc, ProductsState>(
                      builder: (context, state) {
                        return ProductGridWidget(
                          state: state,
                          onRefresh: () => _onRefresh(context),
                          onProductTap: (product) =>
                              _onProductTap(context, product),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  void _onCategorySelected(BuildContext context, String category) {
    context.read<ProductsBloc>().add(LoadProductsByCategory(category));
  }

  void _onProductTap(BuildContext context, product) {
    Navigator.pushNamed(
      context,
      '/product-detail-screen',
      arguments: product,
    );
  }

  void _onSearchTap(BuildContext context) {
    Navigator.pushNamed(context, '/search-screen');
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<ProductsBloc>().add(RefreshProducts());
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
