import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //!Add
  Future<void> addFavorites(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('products')
        .doc(productId)
        .set({
      'productId': productId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  //!remove
  Future<void> removeFromFavorites(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('products')
        .doc(productId)
        .delete();
  }



  //!get
 Stream<List<String>> getFavoriteProductIds() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()['productId'] as String).toList());
  }



  //!check

   Future<bool> isFavorite(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final doc = await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('products')
        .doc(productId)
        .get();

    return doc.exists;
  }
}
