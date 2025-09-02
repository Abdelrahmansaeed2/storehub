import 'package:flutter/material.dart';
import '../presentation/product_detail_screen/product_detail_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/category_screen/category_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String productDetail = '/product-detail-screen';
  static const String splash = '/splash-screen';
  static const String search = '/search-screen';
  static const String home = '/home-screen';
  static const String category = '/category-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    productDetail: (context) => const ProductDetailScreen(),
    splash: (context) => const SplashScreen(),
    search: (context) => const SearchScreen(),
    home: (context) => const HomeScreen(),
    category: (context) => const CategoryScreen(),
    // TODO: Add your other routes here
  };
}
