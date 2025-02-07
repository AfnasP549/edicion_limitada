import 'dart:convert';
import 'package:edicion_limitada/common/utils/constatns/app_color.dart';
import 'package:edicion_limitada/features/home_screen/model/ads_model.dart';
import 'package:edicion_limitada/features/home_screen/service/ads_service.dart';
import 'package:edicion_limitada/features/home_screen/widget/searchbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:edicion_limitada/common/widget/cart_icon_button.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/pages/login_screen.dart';
import 'package:edicion_limitada/features/profile/view/profile_screen.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/features/shopping/view/shopping_screen.dart';
import 'package:edicion_limitada/view_model/service/product_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }


//!appbar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: SizedBox(
        height: 200,
        width: 280,
        child: Image.asset('image/edicion_limitada.png'),
      ),
      actions: [
        const CartIconButton(),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ProfileScreen())
            );
          },
          icon: const Icon(FontAwesomeIcons.user)
        ),
      ],
    );
  }
//!body
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<AuthBloc, AuthState>(
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
            return _buildShimmerLoading();
          } else if (state is AuthError) {
            return const Center(
              child: Text('Auth error'),
            );
          }
          return _buildMainContent(context);
        },
      ),
    );
  }
//!carousel and Product card
  Widget _buildMainContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await ProductService().fetchProducts();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchBarWidget(),
            const SizedBox(height: 10),
            _buildAdsCarousel(context),  
            _buildProductSection(context),
          ],
        ),
      ),
    );
  }

//!Ads carousel
   Widget _buildAdsCarousel(BuildContext context) {
    return FutureBuilder<List<AdsModel>>(
      future: AdsService().fetchAds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading ads: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();  // Don't show anything if no ads
        }

        final adImages = snapshot.data!.map((ad) => 
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              base64Decode(ad.imageUrl),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          )
        ).toList();

        return CarouselSlider(
          items: adImages,
          options: CarouselOptions(
            height: 350,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
          ),
        );
      },
    );
  }


  Widget _buildProductSection(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: ProductService().fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        final products = snapshot.data!;
        return _buildProductContent(context, products);
      },
    );
  }

  Widget _buildProductContent(BuildContext context, List<ProductModel> products) {
    return Column(
      children: [
        _buildSectionHeader(context),
        _buildProductGrid(context, products),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Top Rated Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingScreen(),
                ),
              );
            },
            child:  Text(
              'See all',
              style: TextStyle(
                color: AppColor.textBlue,
                fontSize: 18
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<ProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _buildProductCard(context, products[index]),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final discountedPrice = (product.price - (product.price * (product.offer / 100))).round();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShoppingScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color:AppColor.lightContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.boxShadow,
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: product.imageUrls.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(product.imageUrls[0]),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.phone_iphone,
                          size: 80,
                          color: AppColor.greyContainer,
                        ),
                      ),
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
                  _buildPriceRow(product, discountedPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(ProductModel product, int discountedPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (product.offer > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColor.lgreenContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.offer.toStringAsFixed(0)}% off',
                  style:  TextStyle(
                    color: AppColor.textGreen,
                    fontSize: 12,
                  ),
                ),
              ),
            const Spacer(),
            Text(
              '₹${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                color:  AppColor.textGrey,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColor.textGrey,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '₹$discountedPrice',
          style:  TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerLGrey!,
      highlightColor: AppColor.shimmerGrey!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Search bar shimmer
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            // Carousel shimmer
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Section header shimmer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 20,
                    color: Colors.white,
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            // Product grid shimmer
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 40,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 17,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}