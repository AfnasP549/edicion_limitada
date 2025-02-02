import 'dart:convert';

import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  final OrderItem item;

  const OrderDetailScreen({
    Key? key,
    required this.order,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl.isNotEmpty)
              Center(
                child: Image.memory(
                  base64Decode(item.imageUrl),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              item.productName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Quantity: ${item.quantity}'),
            Text('Price: \$${item.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(
              'Order Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Order Status: ${order.status}'),
            Text('Payment Method: ${order.paymentMethod}'),
            Text('Payment Status: ${order.paymentStatus}'),
            Text(
              'Order Date: ${DateFormat('MMM dd, yyyy hh:mm a').format(order.createdAt)}',
            ),
            const SizedBox(height: 16),
            Text(
              'Shipping Address ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('${order.address}'),


            const SizedBox(height: 8),
            // Add address details here based on your AddressModel
          ],
        ),
      ),
    );
  }
}