part of 'shopping_bloc.dart';

sealed class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ShoppingEvent{
}

class LoadBrands extends ShoppingEvent{}

class FilterByBrand extends ShoppingEvent{
  final String brand;

  const FilterByBrand( this.brand);
}

class SelectProduct extends ShoppingEvent {
  final ProductModel product;
  const SelectProduct(this.product);

  @override
  List<Object> get props => [product];
}

