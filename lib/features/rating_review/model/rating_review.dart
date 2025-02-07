import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String userId;
  final String productId;
  final String orderId;
  final double rating;
  final String review;
  final DateTime createdAt;
  final String userName;

  RatingModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.review,
    required this.createdAt,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'orderId': orderId,
      'rating': rating,
      'review': review,
      'createdAt': createdAt,
      'userName': userName,
    };
  }

  factory RatingModel.fromMap(String id, Map<String, dynamic> map) {
    return RatingModel(
      id: id,
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      orderId: map['orderId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      review: map['review'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userName: map['userName'] ?? '',
    );
  }
}
