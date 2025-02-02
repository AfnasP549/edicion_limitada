import 'dart:convert';
import 'package:edicion_limitada/model/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  final String id;
  
  CartItem({
    required this.product,
    required this.quantity,
    required this.id,
  });

  double get totalPrice => quantity * (product.price - (product.price * (product.offer / 100)));

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    String? id,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
      'id': id,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductModel.fromMap(map['product'] as Map<String,dynamic>),
      quantity: map['quantity'] as int,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) => 
    CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CartItem(product: $product, quantity: $quantity, id: $id)';

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;
    return other.product == product && 
           other.quantity == quantity && 
           other.id == id;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode ^ id.hashCode;
}