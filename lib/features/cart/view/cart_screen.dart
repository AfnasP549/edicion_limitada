import 'package:edicion_limitada/features/address_management/bloc/address_bloc.dart';
import 'package:edicion_limitada/features/address_management/service/address_service.dart';
import 'package:edicion_limitada/features/cart/widget/cart_item.dart';
import 'package:edicion_limitada/features/checkout/bloc/checkout_bloc.dart';
import 'package:edicion_limitada/features/checkout/service/checkou_service.dart';
import 'package:edicion_limitada/features/checkout/view/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cart')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('image/cartempty.json'),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            actions: [
              if (state.items.any((item) => item.product.stock <= 0))
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Remove Out-of-Stock Items'),
                        content: const Text(
                          'Would you like to remove all out-of-stock items from your cart?'
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<CartBloc>().add(RemoveOutOfStockEvent());
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 77, 73, 73),
                            ),
                            child: const Text('Remove', style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Remove all out-of-stock items',
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: AnimatedList(
                  key: GlobalKey<AnimatedListState>(),
                  padding: const EdgeInsets.all(16),
                  initialItemCount: state.items.length,
                  itemBuilder: (context, index, animation) {
                    final item = state.items[index];
                    return SlideTransition(
                      position: animation.drive(Tween(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOut))),
                      child: CartItemWidget(item: item),
                    );
                  },
                ),
              ),
              _buildBottomBar(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStockWarnings(context, state),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<CartBloc, CartState>(
                  buildWhen: (previous, current) =>
                      previous.totalAmount != current.totalAmount,
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${state.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final bool hasStockIssues = state.items.any((item) =>
                        item.quantity > item.product.stock ||
                        item.product.stock <= 0);

                    return ElevatedButton(
                      onPressed: state.items.isEmpty || hasStockIssues
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => CheckoutBloc(
                                      checkoutService: CheckoutService(),
                                      cartBloc: context.read<CartBloc>(),
                                      addressBloc: AddressBloc(
                                        AddressService(
                                          userId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                        ),
                                      )..add(LoadAddressesEvent()),
                                    )..add(InitializeCheckoutEvent()),
                                    child: const CheckoutScreen(),
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Checkout (${state.items.length} items)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockWarnings(BuildContext context, CartState state) {
    final stockIssues = state.items
        .where((item) =>
            item.quantity > item.product.stock || item.product.stock <= 0)
        .toList();

    if (stockIssues.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stockIssues.map((item) {
          if (item.product.stock <= 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.product.name} is out of stock',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                        RemoveFromCartEvent(item.id),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(60, 25),
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${item.product.name} has only ${item.product.stock} units available',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}