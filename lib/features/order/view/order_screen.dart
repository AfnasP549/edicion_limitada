import 'dart:convert';

import 'package:edicion_limitada/features/order/cubit/order_cubit.dart';
import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:edicion_limitada/features/order/service/order_service.dart';
import 'package:edicion_limitada/features/order/view/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(OrderService())..fetchOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _buildOrderCard(context, order);
                },
              );
            } else if (state is OrderError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell( // Wrap with InkWell for better tap feedback
      onTap: () {
        // Handle tap for the entire card if needed
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column( // Change to Column instead of ListView
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
           // Text('Order ID: ${order.id}'), // Add order ID
            const SizedBox(height: 8),
            ...order.items.map((item) => ListTile(
              leading: 
                   Image.memory(
                      base64Decode(item.imageUrl),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  
              title: Text(item.productName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${item.price.toStringAsFixed(2)}'),
                  Text('Status: ${order.status}'),
                  Text('Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt)}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(order: order, item: item),
                  ),
                );
              },
            )).toList(),
          ],
        ),
      ),
    ),
  );
}
}