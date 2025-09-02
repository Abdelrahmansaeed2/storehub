import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_all_products_usecase.dart';
import '../../../domain/usecases/get_products_by_category_usecase.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  ProductsBloc({
    required GetAllProductsUseCase getAllProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  })  : _getAllProductsUseCase = getAllProductsUseCase,
        _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
        super(ProductsInitial()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      final products = await _getAllProductsUseCase();
      emit(ProductsLoaded(
        products: products,
        selectedCategory: null,
      ));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      final products = event.category == null || event.category == 'all'
          ? await _getAllProductsUseCase()
          : await _getProductsByCategoryUseCase(event.category!);

      emit(ProductsLoaded(
        products: products,
        selectedCategory: event.category == 'all' ? null : event.category,
      ));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      try {
        final products = currentState.selectedCategory == null
            ? await _getAllProductsUseCase()
            : await _getProductsByCategoryUseCase(
                currentState.selectedCategory!);

        emit(ProductsLoaded(
          products: products,
          selectedCategory: currentState.selectedCategory,
        ));
      } catch (e) {
        emit(ProductsError(message: e.toString()));
      }
    } else {
      add(LoadAllProducts());
    }
  }
}
