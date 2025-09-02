import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/datasources/product_api_service.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../../presentation/bloc/products/products_bloc.dart';
import '../../presentation/bloc/categories/categories_bloc.dart';
import '../../presentation/bloc/search/search_bloc.dart';

class DependencyInjection {
  static late final Dio _dio;
  static late final Connectivity _connectivity;
  static late final ProductApiService _productApiService;
  static late final ProductRepository _productRepository;

  // Use cases
  static late final GetAllProductsUseCase _getAllProductsUseCase;
  static late final GetCategoriesUseCase _getCategoriesUseCase;
  static late final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  static late final SearchProductsUseCase _searchProductsUseCase;

  static void initialize() {
    // External dependencies
    _dio = Dio();
    _connectivity = Connectivity();

    // Data layer
    _productApiService = ProductApiService(dio: _dio);
    _productRepository = ProductRepositoryImpl(
      apiService: _productApiService,
      connectivity: _connectivity,
    );

    // Domain layer
    _getAllProductsUseCase = GetAllProductsUseCase(_productRepository);
    _getCategoriesUseCase = GetCategoriesUseCase(_productRepository);
    _getProductsByCategoryUseCase =
        GetProductsByCategoryUseCase(_productRepository);
    _searchProductsUseCase = SearchProductsUseCase(_productRepository);
  }

  // BLoCs
  static ProductsBloc createProductsBloc() {
    return ProductsBloc(
      getAllProductsUseCase: _getAllProductsUseCase,
      getProductsByCategoryUseCase: _getProductsByCategoryUseCase,
    );
  }

  static CategoriesBloc createCategoriesBloc() {
    return CategoriesBloc(
      getCategoriesUseCase: _getCategoriesUseCase,
    );
  }

  static SearchBloc createSearchBloc() {
    return SearchBloc(
      searchProductsUseCase: _searchProductsUseCase,
    );
  }

  // Getters for testing
  static ProductRepository get productRepository => _productRepository;
  static GetAllProductsUseCase get getAllProductsUseCase =>
      _getAllProductsUseCase;
  static GetCategoriesUseCase get getCategoriesUseCase => _getCategoriesUseCase;
  static SearchProductsUseCase get searchProductsUseCase =>
      _searchProductsUseCase;
}
