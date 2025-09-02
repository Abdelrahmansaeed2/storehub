import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<Product>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _repository.searchProducts(query);
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}
