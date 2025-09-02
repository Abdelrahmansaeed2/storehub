import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
  Future<List<Product>> searchProducts(String query);
}
