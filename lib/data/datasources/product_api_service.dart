import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://fakestoreapi.com';

  ProductApiService({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _dio.get('/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch products',
        );
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/products'),
          message: 'Unexpected error: $e',
        );
      }
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch products by category',
        );
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/products/category/$category'),
          message: 'Unexpected error: $e',
        );
      }
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<String>();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch categories',
        );
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/products/categories'),
          message: 'Unexpected error: $e',
        );
      }
    }
  }
}
