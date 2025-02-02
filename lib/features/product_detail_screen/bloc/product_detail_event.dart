part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}


class ChangeDisplayedImage extends ProductDetailEvent{
  final int index;

  const ChangeDisplayedImage(this.index);
}

class AddToCartRequested extends ProductDetailEvent {
  final ProductModel product;
  const AddToCartRequested(this.product);
}

class AddToCartCompleted extends ProductDetailEvent {}
