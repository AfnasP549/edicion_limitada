import 'dart:convert';
import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:edicion_limitada/features/order/service/order_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  Stream<List<OrderModel>> getOrdersStream() {
    return _orderService.getOrdersStream();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> cancelOrder(BuildContext context, OrderModel order) async {
    try {
      await _orderService.cancelOrder(order);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cancelling order: $e')),
        );
      }
    }
  }
}
