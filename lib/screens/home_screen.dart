import 'dart:convert';

import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/pages/login_screen.dart';
import 'package:edicion_limitada/features/profile/view/Profile_screen.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/screens/search_screen.dart';
import 'package:edicion_limitada/features/shopping/view/shopping_screen.dart';
import 'package:edicion_limitada/view_model/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 200,
            width: 280,
            child: Image.asset('image/edicion_limitada.png'),
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(FontAwesomeIcons.bell)),
            IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.bagShopping)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                },
                icon: const Icon(FontAwesomeIcons.user)),
          ],
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          buildWhen: (previous, current) {
            return current is AuthSuccess ||
                current is AuthError ||
                current is AuthLoading;
          },
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: Lottie.asset('image/lottie loading 3.json'));
            } else if (state is AuthError) {
              return const Center(
                child: Text('Auth error'),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSearchBar(context),
                    SizedBox(height: 10),
                    FutureBuilder<List<ProductModel>>(
                      future: ProductService().fetchProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  Lottie.asset('image/lottie loading 3.json'));
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No products available');
                        }

                        final products = snapshot.data!;
                        final displayProducts = products.take(6).toList();

                        // Use first two products for carousel
                        final carouselImages = displayProducts
                            .take(2)
                            .map((product) => ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.memory(
                                    base64Decode(product.imageUrls[0]),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ))
                            .toList();

                        return Column(
                          children: [
                            CarouselSlider(
                              items: carouselImages,
                              options: CarouselOptions(
                                height: 350,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Top Rated Products',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ShoppingScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'See all',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                235, 91, 158, 225),
                                            fontSize: 18),
                                      ))
                                ],
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: displayProducts.length,
                              itemBuilder: (context, index) {
                                final product = displayProducts[index];
                                final discountedPrice = (product.price -
                                        (product.price * (product.offer / 100)))
                                    .round();

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ShoppingScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    //width: double.infinity,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: product.imageUrls.isNotEmpty
                                                ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  child: Image.memory(
                                                    base64Decode(product
                                                        .imageUrls[0]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                : Container(
                                                    color: Colors.grey[100],
                                                    child: const Icon(
                                                      Icons.phone_iphone,
                                                      size: 80,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
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
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 14,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          Colors.grey,
                                                      decorationThickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '₹$discountedPrice',
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
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchScreen()));
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                Text(
                  'Explore Limited Editions...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
