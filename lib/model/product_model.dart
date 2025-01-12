// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductModel {
  final String id;
  final String name;
  final String brand;
  final List<String> imageUrls;
  final String description;
  final int ram;
  final int rom;
  final double offer;
  final String processor;
  final int stock;
  final double price;
  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrls,
    required this.description,
    required this.ram,
    required this.rom,
    required this.offer,
    required this.processor,
    required this.stock,
    required this.price,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    List<String>? imageUrls,
    String? description,
    int? ram,
    int? rom,
    double? offer,
    String? processor,
    int? stock,
    double? price,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrls: imageUrls ?? this.imageUrls,
      description: description ?? this.description,
      ram: ram ?? this.ram,
      rom: rom ?? this.rom,
      offer: offer ?? this.offer,
      processor: processor ?? this.processor,
      stock: stock ?? this.stock,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'brand': brand,
      'imageUrls': imageUrls,
      'description': description,
      'ram': ram,
      'rom': rom,
      'offer': offer,
      'processor': processor,
      'stock': stock,
      'price': price,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String,
      imageUrls: List<String>.from((map['imageUrls'] as List<String>)),
      description: map['description'] as String,
      ram: map['ram'] as int,
      rom: map['rom'] as int,
      offer: map['offer'] as double,
      processor: map['processor'] as String,
      stock: map['stock'] as int,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, brand: $brand, imageUrls: $imageUrls, description: $description, ram: $ram, rom: $rom, offer: $offer, processor: $processor, stock: $stock, price: $price)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.brand == brand &&
      listEquals(other.imageUrls, imageUrls) &&
      other.description == description &&
      other.ram == ram &&
      other.rom == rom &&
      other.offer == offer &&
      other.processor == processor &&
      other.stock == stock &&
      other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      brand.hashCode ^
      imageUrls.hashCode ^
      description.hashCode ^
      ram.hashCode ^
      rom.hashCode ^
      offer.hashCode ^
      processor.hashCode ^
      stock.hashCode ^
      price.hashCode;
  }
}
