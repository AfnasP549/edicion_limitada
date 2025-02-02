part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({
    required this.items,
    this.isLoading = false,
    this.error,
  });

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.totalPrice));
  }

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error];
}


