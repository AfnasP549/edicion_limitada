import 'dart:convert';

import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';

class CheckoutModel {
  final List<CartItem> items;
  final AddressModel? selectedAddress;
  final double totalAmount;
  final String? orderId;
  final String status;

  CheckoutModel({
    required this.items,
    this.selectedAddress,
    required this.totalAmount,
    this.orderId,
    this.status = 'pending',
  });

  CheckoutModel copyWith({
    List<CartItem>? items,
    AddressModel? selectedAddress,
    double? totalAmount,
    String? orderId,
    String? status,
  }) {
    return CheckoutModel(
      items: items ?? this.items,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'selectedAddress': selectedAddress?.toMap(),
      'totalAmount': totalAmount,
      'orderId': orderId,
      'status': status,
    };
  }

  factory CheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckoutModel(
      items: (map['items'] as List<dynamic>?)
              ?.map((x) => CartItem.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      selectedAddress: map['selectedAddress'] != null
          ? AddressModel.fromMap(
              map['selectedAddress']['id'], // Pass id explicitly
              map['selectedAddress'] as Map<String, dynamic>,
            )
          : null,
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      orderId: map['orderId'] as String?,
      status: map['status'] ?? 'pending',
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckoutModel.fromJson(String source) =>
      CheckoutModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CheckoutModel(items: $items, selectedAddress: $selectedAddress, totalAmount: $totalAmount, orderId: $orderId, status: $status)';
  }
}
