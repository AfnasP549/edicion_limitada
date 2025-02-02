// ignore_for_file: unused_element

import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final PageController pageController;
  final ProductModel product;

  ProductDetailBloc({
    required this.product,
  })  : pageController = PageController(initialPage: 0),
        super(ProductDetailState(displayedImageIndex: 0, product: product)) {
    on<ChangeDisplayedImage>((event, emit) async {
      try {
        await pageController.animateToPage(
          event.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        emit(state.copyWith(displayedImageIndex: event.index));
      } catch (e) {
        // Log or handle the error gracefully
        debugPrint('Error animating to page: $e');
      }
    });

     on<AddToCartRequested>((event, emit) async {
      emit(state.copyWith(isAddingToCart: true));
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));
      emit(state.copyWith(isAddingToCart: false));
      add(AddToCartCompleted());
    });

    on<AddToCartCompleted>((event, emit) {
      emit(state.copyWith(isAddingToCart: false));
    });
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
