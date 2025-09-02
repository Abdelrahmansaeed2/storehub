import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository _repository;

  GetAllProductsUseCase(this._repository);

  Future<List<Product>> call() async {
    try {
      return await _repository.getAllProducts();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }
}
