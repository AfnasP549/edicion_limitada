import 'dart:convert';

import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:edicion_limitada/features/cart/widget/quantity_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = item.product.stock <= 0;
    final bool exceedsStock = item.quantity > item.product.stock;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isOutOfStock || exceedsStock
              ? Colors.red.shade200
              : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(12),
        color:
            isOutOfStock || exceedsStock ? Colors.red[50] : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.product.imageUrls.isNotEmpty
                      ? Image.memory(
                          base64Decode(item.product.imageUrls.first),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Error loading image: $error');
                            return const Icon(Icons.phone_iphone);
                          },
                        )
                      : const Icon(Icons.phone_iphone),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<CartBloc, CartState>(
                      buildWhen: (previous, current) {
                        final previousItem =
                            previous.items.firstWhere((i) => i.id == item.id);
                        final currentItem =
                            current.items.firstWhere((i) => i.id == item.id);
                        return previousItem.totalPrice !=
                            currentItem.totalPrice;
                      },
                      builder: (context, state) {
                        return Text(
                          '₹${item.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (!isOutOfStock) QuantityControls(item: item),
            ],
          ),
          if (isOutOfStock)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Out of Stock',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (exceedsStock)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Only ${item.product.stock} units available',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}