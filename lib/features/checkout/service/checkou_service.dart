import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  //! Place Order
  Future<String> placeOrder({
    required List<CartItem> items,
    required AddressModel address,
    required double totalAmount,
    required String paymentMethod,
    required String paymentStatus,
  }) async {
    try {
      if (items.isEmpty) throw Exception('No items in the cart.');
      if (totalAmount <= 0) throw Exception('Invalid total amount.');

      // Create a batch for atomic operations
      final batch = _firestore.batch();
      final orderRef = _firestore.collection('orders').doc();

      // First, verify stock availability for all items
      for (var item in items) {
        final productDoc =
            await _firestore.collection('product').doc(item.product.id).get();
        if (!productDoc.exists) {
          throw Exception('Product ${item.product.name} no longer exists');
        }

        final currentStock = productDoc.data()?['stock'] ?? 0;
        if (currentStock < item.quantity) {
          throw Exception('Insufficient stock for ${item.product.name}');
        }
      }

      // Create order document
      final orderData = {
        'userId': userId,
        'items': items
            .map((item) => {
                  'productId': item.product.id,
                  'quantity': item.quantity,
                  'price': item.totalPrice,
                  'productName': item.product.name,
                  'imageUrl': item.product.imageUrls.isNotEmpty
                      ? item.product.imageUrls.first
                      : '',
                  'imageUrls': item.product.imageUrls,
                })
            .toList(),
        'totalAmount': totalAmount,
        'status': 'pending',
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus == 'Online Payment' ? 'Paid' : 'Paid',
        'createdAt': FieldValue.serverTimestamp(),
        'address': address.toMap(),
      };

      batch.set(orderRef, orderData);

      // Update product stock
      for (var item in items) {
        final productRef =
            _firestore.collection('product').doc(item.product.id);
        batch.update(productRef, {
          'stock': FieldValue.increment(-item.quantity),
          'soldCount': FieldValue.increment(item.quantity),
        });
      }

      // Clear cart items
      final cartQuery = await _firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in cartQuery.docs) {
        batch.delete(doc.reference);
      }

      // Link order to user
      final userOrderRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderRef.id);

      batch.set(userOrderRef, {
        'orderId': orderRef.id,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      return orderRef.id;
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }
  
}
