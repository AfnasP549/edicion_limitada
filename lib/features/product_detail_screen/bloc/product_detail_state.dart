part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  final int displayedImageIndex;
  final ProductModel product;
  final bool isAddingToCart;

  const ProductDetailState({
    required this.displayedImageIndex,
    required this.product,
    this.isAddingToCart = false,
  });

  ProductDetailState copyWith({
    int? displayedImageIndex,
    ProductModel? product,
    bool? isAddingToCart,
  }) {
    return ProductDetailState(
      displayedImageIndex: displayedImageIndex ?? this.displayedImageIndex,
      product: product ?? this.product,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }

  @override
  List<Object> get props => [displayedImageIndex, product, isAddingToCart];
}