// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:edicion_limitada/features/product_detail_screen/view/product_detail_screen.dart';
import 'package:edicion_limitada/features/shopping/bloc/shopping_bloc.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FC),
      body: SafeArea(
        child: BlocBuilder<ShoppingBloc, ShoppingState>(
          builder: (context, state) {
            if (state is ShoppingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ShoppinError) {
              return Center(child: Text(state.message));
            }

            if (state is ShoppingLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Shopping',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Explore Limited Editions...',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )),
                            ),
                          ),
                          SizedBox(height: 10),
                          //_buildSearchBar(),
                          _buildBrandsList(state.brands, state.selectedBrand),
                        ],
                      ),
                    ),
                  ),
                  _buildProductGrid(context, state.products),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBrandsList(List<String> brands, String? selectedBrand) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length + 1, // +1 for the "All" button
        itemBuilder: (context, index) {
          final isAllOption = index == 0;
          final brand = isAllOption ? "All" : brands[index - 1];
          final isSelected =
              isAllOption ? selectedBrand == null : selectedBrand == brand;

          return GestureDetector(
            onTap: () {
              if (isAllOption) {
                context.read<ShoppingBloc>().add(LoadProducts());
              } else {
                context.read<ShoppingBloc>().add(FilterByBrand(brand));
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[100] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                brand,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<ProductModel> products) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final discountedPrice = (products[index].price -
                    (products[index].price * (products[index].offer / 100)))
                .round();
            return _buildProductCard(context, products[index], discountedPrice);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, ProductModel product, int discountPrice) {
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
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _buildProductImage(product),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                  Text(
                    '₹$discountPrice',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ],
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
      width: 100,
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
}
