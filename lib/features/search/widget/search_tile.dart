import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/features/product_detail_screen/view/product_detail_screen.dart';

class ProductSearchTile extends StatelessWidget {
  final ProductModel product;

  const ProductSearchTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        (product.price - (product.price * (product.offer / 100))).round();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: product.imageUrls.isNotEmpty
            ? SizedBox(
                width: 50,
                height: 50,
                child: Image.memory(
                  base64Decode(product.imageUrls[0]),
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.phone_android),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.brand),
            Text(
              '₹$discountedPrice',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: product.offer > 0
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.offer.toStringAsFixed(0)}% off',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                  ),
                ),
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
      ),
    );
  }
}
