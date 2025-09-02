import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../datasources/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _apiService;
  final Connectivity _connectivity;

  ProductRepositoryImpl({
    required ProductApiService apiService,
    required Connectivity connectivity,
  })  : _apiService = apiService,
        _connectivity = connectivity;

  @override
  Future<List<Product>> getAllProducts() async {
    await _checkConnectivity();

    try {
      final productModels = await _apiService.getAllProducts();
      return productModels.map((model) => _mapToEntity(model)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await _checkConnectivity();

    try {
      final productModels = await _apiService.getProductsByCategory(category);
      return productModels.map((model) => _mapToEntity(model)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    await _checkConnectivity();

    try {
      return await _apiService.getCategories();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await _checkConnectivity();

    try {
      final allProducts = await _apiService.getAllProducts();
      final filteredProducts = allProducts.where((product) {
        final searchQuery = query.toLowerCase();
        return product.title.toLowerCase().contains(searchQuery) ||
            product.description.toLowerCase().contains(searchQuery) ||
            product.category.toLowerCase().contains(searchQuery);
      }).toList();

      return filteredProducts.map((model) => _mapToEntity(model)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw Exception('No internet connection');
    }
  }

  Product _mapToEntity(ProductModel model) {
    return Product(
      id: model.id,
      title: model.title,
      price: model.price,
      description: model.description,
      category: model.category,
      image: model.image,
      rating: Rating(
        rate: model.rating.rate,
        count: model.rating.count,
      ),
    );
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 404) {
          return Exception('Products not found');
        } else if (e.response?.statusCode == 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception('Failed to load data. Please try again.');
      default:
        return Exception('An unexpected error occurred');
    }
  }
}
