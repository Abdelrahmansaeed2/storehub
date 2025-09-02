import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:storehub/domain/entities/product.dart';
import 'package:storehub/domain/repositories/product_repository.dart';
import 'package:storehub/domain/usecases/get_all_products_usecase.dart';

import 'get_all_products_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetAllProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetAllProductsUseCase(mockRepository);
  });

  group('GetAllProductsUseCase', () {
    final tProducts = [
      const Product(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'test_image.jpg',
        rating: Rating(rate: 4.5, count: 100),
      ),
    ];

    test('should get products from the repository', () async {
      // arrange
      when(mockRepository.getAllProducts()).thenAnswer((_) async => tProducts);

      // act
      final result = await useCase();

      // assert
      expect(result, tProducts);
      verify(mockRepository.getAllProducts());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // arrange
      when(mockRepository.getAllProducts())
          .thenThrow(Exception('Repository error'));

      // act & assert
      expect(() => useCase(), throwsException);
    });
  });
}
