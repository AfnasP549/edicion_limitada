import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  CartService() : _firestore = FirebaseFirestore.instance;


//!fetch
  Future<List<CartItem>> fetchCart() async {
    final snapshot = await _firestore.collection('carts').get();
    if (snapshot.docs.isEmpty) return [];
    final productIds = snapshot.docs
        .map((doc) => (doc.data()['productId'] as String))
        .toList();
    if (productIds.isEmpty) return [];
    final productsSnapshot = await _firestore
        .collection('product')
        .where(FieldPath.documentId, whereIn: productIds)
        .get();
    final productsMap = {
      for (var doc in productsSnapshot.docs)
        doc.id: ProductModel.fromMap({...doc.data(), 'id': doc.id})
    };
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final product = productsMap[data['productId']];
      if (product != null) {
        return CartItem(
          product: product,
          quantity: data['quantity'] ?? 1,
          id: doc.id,
        );
      }
      return null;
    }).whereType<CartItem>().toList();
  }


//!add
  Future<void> addToCart(ProductModel product, int quantity) async {
    final cartQuery = await _firestore
        .collection('carts')
        .where('productId', isEqualTo: product.id)
        .get();

    if (cartQuery.docs.isNotEmpty) {
      final existingDoc = cartQuery.docs.first;
      final currentQuantity = existingDoc.data()['quantity'] as int? ?? 0;

      await existingDoc.reference.update({
        'quantity': currentQuantity + quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _firestore.collection('carts').add({
        'productId': product.id,
        'quantity': quantity,
        'imageUrl' : product.imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }


//!delete from cart
Future<void> removeFromCart(String documentId) async {
  try {
    await _firestore.collection('carts').doc(documentId).delete();
    print('Successfully removed document: $documentId');
  } catch (e) {
    print('Error removing document: $e');
    throw Exception('Failed to remove Cart Item: $e');
  }
}


  Future<void> updateQuantity(String productId, int quantity) async {
    await _firestore.collection('carts').doc(productId).update({
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

 
//!clear cart
   Future<void> clearCart() async {
    try {
      final cartQuery = await _firestore
          .collection('carts')
          .get(); // Remove the where clause since userId isn't stored

      final batch = _firestore.batch();
      
      for (var doc in cartQuery.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
