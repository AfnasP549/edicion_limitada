// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'shopping_bloc.dart';

sealed class ShoppingState extends Equatable {
  const ShoppingState();
  
  @override
  List<Object> get props => [];
}

final class ShoppingInitial extends ShoppingState {}

class ShoppingLoading extends ShoppingState{}

class ShoppingLoaded extends ShoppingState {
  final List<ProductModel> products;
  final List<String> brands;
  final String? selectedBrand;
  final ProductModel? selectedProduct;


  const ShoppingLoaded({
    required this.products,
    required this.brands,
    this.selectedBrand,
    this.selectedProduct,
  });

  
}


class ShoppinError extends ShoppingState{
  final String message;

  const ShoppinError( this.message);
}