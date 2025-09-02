import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:storehub/domain/entities/product.dart';
import 'package:storehub/domain/usecases/get_all_products_usecase.dart';
import 'package:storehub/domain/usecases/get_products_by_category_usecase.dart';
import 'package:storehub/presentation/bloc/products/products_bloc.dart';

import 'products_bloc_test.mocks.dart';

@GenerateMocks([GetAllProductsUseCase, GetProductsByCategoryUseCase])
void main() {
  late ProductsBloc bloc;
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;
  late MockGetProductsByCategoryUseCase mockGetProductsByCategoryUseCase;

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    mockGetProductsByCategoryUseCase = MockGetProductsByCategoryUseCase();

    bloc = ProductsBloc(
      getAllProductsUseCase: mockGetAllProductsUseCase,
      getProductsByCategoryUseCase: mockGetProductsByCategoryUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProductsBloc', () {
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

    test('initial state is ProductsInitial', () {
      expect(bloc.state, ProductsInitial());
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when LoadAllProducts is added',
      build: () {
        when(mockGetAllProductsUseCase()).thenAnswer((_) async => tProducts);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProducts()),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded(products: tProducts, selectedCategory: null),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsError] when LoadAllProducts fails',
      build: () {
        when(mockGetAllProductsUseCase())
            .thenThrow(Exception('Failed to load products'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProducts()),
      expect: () => [
        ProductsLoading(),
        const ProductsError(message: 'Exception: Failed to load products'),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when LoadProductsByCategory is added',
      build: () {
        when(mockGetProductsByCategoryUseCase('electronics'))
            .thenAnswer((_) async => tProducts);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadProductsByCategory('electronics')),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded(products: tProducts, selectedCategory: 'electronics'),
      ],
    );
  });
}
