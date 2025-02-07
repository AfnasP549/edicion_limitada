// ignore_for_file: must_be_immutable

import 'package:edicion_limitada/common/widget/cart_icon_button.dart';
import 'package:edicion_limitada/features/favorite/bloc/favorite_bloc.dart';
import 'package:edicion_limitada/features/favorite/service/favorite_service.dart';
import 'package:edicion_limitada/features/shopping/bloc/shopping_bloc.dart';
import 'package:edicion_limitada/features/shopping/widget/product_card.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/features/search/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FC),
      body: BlocProvider(
        create: (context) =>
            FavoriteBloc(FavoriteService())..add(LoadFavoritesEvent()),
        child: SafeArea(
          child: BlocBuilder<ShoppingBloc, ShoppingState>(
            builder: (context, state) {
              if (state is ShoppingLoading) {
                return Center(
                    child: Lottie.asset('image/lottie loading 3.json'));
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
                                    CartIconButton(),

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
      ),
    );
  }

  //!shows the brands list for filtering
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
                  color: isSelected
                      ? Colors.blue
                      : const Color.fromARGB(255, 31, 28, 28),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //!PRoduct grid
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
            return ProductCard(
                product: products[index], discountPrice: discountedPrice);
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
