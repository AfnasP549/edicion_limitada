// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:edicion_limitada/features/cart/service/cart_service.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';



class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;

  CartBloc() : _cartService = CartService(), super(const CartState(items: [], isLoading: true)) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<LoadCartEvent>(_onLoadCart);
    on<ClearCartEvent>(_onClearCart);
    on<RemoveOutOfStockEvent>(_onRemoveOutOfStock);
    

    add(LoadCartEvent());
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final items = await _cartService.fetchCart();
      emit(state.copyWith(items: items, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load cart: $e', isLoading: false));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartService.addToCart(event.product, event.quantity);
      add(LoadCartEvent());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add item to cart: $e', isLoading: false));
    }
  }


//!remove from cart
  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
  try {
    print('Remove event received for product: ${event.productId}');
    emit(state.copyWith(isLoading: true));
    await _cartService.removeFromCart(event.productId);
    add(LoadCartEvent());
  } catch (e) {
    print('Remove from cart failed: $e');
    emit(state.copyWith(error: 'Failed to remove item from cart: $e', isLoading: false));
  }
}

  //!update quantity

 Future<void> _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) async {
  try {
    emit(state.copyWith(isLoading: false));
    
    // Find the current item
    final currentItem = state.items.firstWhere((item) => item.id == event.productId);
    
    // Check if new quantity exceeds stock
    if (event.quantity > currentItem.product.stock) {
      emit(state.copyWith(
        error: 'Cannot exceed available stock of ${currentItem.product.stock}',
        isLoading: false,
      ));
      return;
    }
    
    await _cartService.updateQuantity(event.productId, event.quantity);
    add(LoadCartEvent());
  } catch (e) {
    emit(state.copyWith(error: 'Failed to update item quantity: $e', isLoading: false));
  }
}

Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartService.clearCart();
      emit(state.copyWith(
        items: [], 
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to clear cart: $e',
        isLoading: false,
      ));
    }
  }


//!remove out of stock
    Future<void> _onRemoveOutOfStock(
    RemoveOutOfStockEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartService.removeOutOfStockItems();
      add(LoadCartEvent());
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to remove out-of-stock items: $e',
        isLoading: false,
      ));
    }
}
}
