import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<List<String>> call() async {
    try {
      return await _repository.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }
}
