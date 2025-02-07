import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/rating_review/model/rating_review.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addRating({
    required String productId,
    required String orderId,
    required double rating,
    required String review,
  }) async {
    try {
      // Get user's display name
      final user = FirebaseAuth.instance.currentUser;
      final userName = user?.displayName ?? 'Anonymous';

      await _firestore.collection('ratings').add({
        'userId': userId,
        'productId': productId,
        'orderId': orderId,
        'rating': rating,
        'review': review,
        'createdAt': Timestamp.now(),
        'userName': userName,
      });

      // Update average rating in products collection
      await updateProductAverageRating(productId);
    } catch (e) {
      throw Exception('Failed to add rating: $e');
    }
  }

  Future<void> updateProductAverageRating(String productId) async {
    try {
      final ratings = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .get();

      if (ratings.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in ratings.docs) {
          totalRating += (doc.data()['rating'] as num).toDouble();
        }
        double averageRating = totalRating / ratings.docs.length;

        await _firestore.collection('products').doc(productId).update({
          'averageRating': averageRating,
          'ratingCount': ratings.docs.length,
        });
      }
    } catch (e) {
      print('Error updating average rating: $e');
    }
  }

  Future<List<RatingModel>> getProductRatings(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RatingModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch ratings: $e');
    }
  }

  Future<bool> hasUserRatedProduct(String productId, String orderId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .where('orderId', isEqualTo: orderId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check rating status: $e');
    }
  }
}