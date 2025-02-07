  import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:edicion_limitada/features/address_management/model/address_model.dart';
  import 'package:edicion_limitada/features/order/model/order_model.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  // order_service.dart
  class OrderService {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    Stream<List<OrderModel>> getOrdersStream() {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final itemsList = (data['items'] as List<dynamic>?) ?? [];

      final items = itemsList.map((item) {
        return OrderItem(
          productId: item['productId'] ?? '',
          quantity: item['quantity'] ?? 0,
          price: (item['price'] ?? 0.0).toDouble(),
          productName: item['productName'] ?? '',
          imageUrls: List<String>.from(item['imageUrls'] ?? []),
          imageUrl: item['imageUrl'] ?? '',
        );
      }).toList();

      return OrderModel(
        id: doc.id,
        userId: data['userId'] ?? '',
        items: items, // Use the mapped items list
        address: AddressModel.fromMap('', data['address'] as Map<String, dynamic>? ?? {}),
        totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
        status: data['status'] ?? '',
        paymentMethod: data['paymentMethod'] ?? '',
        paymentStatus: data['paymentStatus'] ?? '',
        createdAt: data['createdAt'] != null 
            ? (data['createdAt'] as Timestamp).toDate() 
            : DateTime.now(),
      );
    }).toList();
  });
}

   Future<void> cancelOrder(OrderModel order) async {
  try {
    final batch = _firestore.batch();
    final orderRef = _firestore.collection('orders').doc(order.id);

    // Update order status to cancelled
    batch.update(orderRef, {'status': 'Cancelled'});

    for (var item in order.items) {
      final productRef = _firestore.collection('products').doc(item.productId);
      final productDoc = await productRef.get();
      
      if (productDoc.exists) {
        final currentStock = productDoc.data()?['stock'] ?? 0;
        final newStock = currentStock + item.quantity;

        // Debug log before updating stock
        log('Updating stock for product ${item.productId}: $currentStock -> $newStock');

        batch.update(productRef, {'stock': newStock});
      }
    }

    await batch.commit();
  } catch (e) {
    log('Failed to cancel order: $e');
    throw Exception('Failed to cancel order: $e');
  }
}


  // Add this method to check if order can be cancelled
  bool canCancelOrder(OrderModel order) {
    return order.status != 'Delivered' && order.status != 'Cancelled';
  }

  } 