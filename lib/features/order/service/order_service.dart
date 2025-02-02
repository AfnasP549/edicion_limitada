import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// order_service.dart
class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      print('Fetching orders for user: $userId'); // Debug print

      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      print('Query snapshot size: ${querySnapshot.size}'); // Debug print

      if (querySnapshot.docs.isEmpty) {
        print('No orders found'); // Debug print
        return [];
      }

       if (querySnapshot.docs.isNotEmpty) {
      print('First order data: ${querySnapshot.docs.first.data()}');
    }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        print('Order data: $data'); // Debug print
        
        final itemsList = (data['items'] as List<dynamic>?) ?? [];
        print('Items list: $itemsList'); // Debug print

        final items = itemsList.map((item) {
          print('Processing item: $item'); // Debug print
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
          items: items,
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
      
    } catch (e) {
      print('Error fetching orders: $e'); // Debug print
      print('Stack trace: ${StackTrace.current}'); // Debug print
      throw Exception('Failed to fetch orders: $e');
    }
  }
}