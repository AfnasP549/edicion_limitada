import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final AddressModel address;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final addressData = data['address'] as Map<String, dynamic>;
    
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      // Pass both the id and map to AddressModel.fromMap
      address: AddressModel.fromMap(
        addressData['id'] ?? '',  // Pass the address id
        addressData,  // Pass the address data map
      ),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: data['status'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'address': address.toMap(),  
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;
  final String productName;
  final List<String> imageUrls;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.imageUrls,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      productName: map['productName'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
      'imageUrls': imageUrls,
      'imageUrl': imageUrl,
    };
  }
}