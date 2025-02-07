import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:edicion_limitada/features/favorite/bloc/favorite_bloc.dart';
import 'package:edicion_limitada/features/product_detail_screen/view/product_detail_screen.dart';
import 'package:edicion_limitada/model/product_model.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final int discountPrice;

  const ProductCard({
    super.key,
    required this.product,
    required this.discountPrice,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return buildProductCard(context, widget.product, widget.discountPrice);
  }

  Widget buildProductCard(BuildContext context, ProductModel product, int discountPrice) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: _buildProductImage(product),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Updated Rating Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('ratings')
                              .where('productId', isEqualTo: product.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(height: 20);
                            }

                            if (snapshot.hasError || !snapshot.hasData) {
                              return _buildNoRating();
                            }

                            final ratings = snapshot.data!.docs;
                            if (ratings.isEmpty) {
                              return _buildNoRating();
                            }

                            double totalRating = 0;
                            for (var doc in ratings) {
                              final data = doc.data() as Map<String, dynamic>;
                              totalRating += (data['rating'] as num).toDouble();
                            }
                            final averageRating = totalRating / ratings.length;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RatingBarIndicator(
                                  rating: averageRating,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 16,
                                  unratedColor: Colors.amber.withOpacity(0.3),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${ratings.length})',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (product.offer > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${product.offer.toStringAsFixed(0)}% off',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const Spacer(),
                          Text(
                            '₹${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹$discountPrice',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(product.stock.toStringAsFixed(0)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: BlocBuilder<FavoriteBloc, FavoriteState>(
                  buildWhen: (previous, current) {
                    if (previous is FavoriteLoadedState && 
                        current is FavoriteLoadedState) {
                      return previous.favoriteIds.contains(product.id) != 
                             current.favoriteIds.contains(product.id);
                    }
                    return true;
                  },
                  builder: (context, state) {
                    bool isLiked = false;
                    if (state is FavoriteLoadedState) {
                      isLiked = state.favoriteIds.contains(product.id);
                    }
                    
                    return LikeButton(
                      size: 24,
                      isLiked: isLiked,
                      onTap: (bool isLiked) async {
                        final favoriteBloc = context.read<FavoriteBloc>();
                        if (isLiked) {
                          favoriteBloc.add(RemoveFromFavoritesEvent(product.id));
                        } else {
                          favoriteBloc.add(AddTOFavoritesEvent(product.id));
                        }
                        return !isLiked;
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey[400],
                          size: 20,
                        );
                      },
                      padding: const EdgeInsets.all(8),
                      animationDuration: const Duration(milliseconds: 500),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    if (product.imageUrls.isEmpty) {
      return _buildPlaceholder();
    }
    return SizedBox(
      width: 120,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          base64Decode(product.imageUrls[0]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: const Icon(
        Icons.phone_iphone,
        size: 80,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildNoRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star_border,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          'No ratings',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}