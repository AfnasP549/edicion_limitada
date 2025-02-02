import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:edicion_limitada/features/cart/widget/delete_confirmation.dart';
import 'package:edicion_limitada/features/cart/widget/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuantityControls extends StatelessWidget {
  final CartItem item;

  const QuantityControls({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) {
        final previousItem = previous.items.firstWhere((i) => i.id == item.id);
        final currentItem = current.items.firstWhere((i) => i.id == item.id);
        return previousItem.quantity != currentItem.quantity;
      },
      builder: (context, state) {
        final currentItem = state.items.firstWhere((i) => i.id == item.id);
        final bool reachedStockLimit =
            currentItem.quantity >= currentItem.product.stock;

        return Row(
          children: [
            QuantityButton(
              icon: Icons.remove,
              onPressed: () {
                if (currentItem.quantity > 1) {
                  context.read<CartBloc>().add(
                        UpdateQuantityEvent(
                          currentItem.id,
                          currentItem.quantity - 1,
                        ),
                      );
                } else {
                  context.read<CartBloc>().add(
                        RemoveFromCartEvent(currentItem.id),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item removed from cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '${currentItem.quantity}',
                key: ValueKey<int>(currentItem.quantity),
                style: TextStyle(
                  color: reachedStockLimit ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            QuantityButton(
              icon: Icons.add,
              onPressed: reachedStockLimit
                  ? null
                  : () {
                      if (currentItem.quantity < currentItem.product.stock) {
                        context.read<CartBloc>().add(
                              UpdateQuantityEvent(
                                currentItem.id,
                                currentItem.quantity + 1,
                              ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Only ${currentItem.product.stock} units available'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
            ),

            //!delete
            IconButton(
              icon: Icon(
                Icons.delete,
                color: const Color.fromARGB(255, 236, 78, 66),
              ),
              onPressed: () => showDeleteConfirmation(context, currentItem),
            )
          ],
        );
      },
    );
  }
}
