part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProducts extends ProductsEvent {}

class LoadProductsByCategory extends ProductsEvent {
  final String? category;

  const LoadProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class RefreshProducts extends ProductsEvent {}
