import 'dart:developer';

import 'package:edicion_limitada/features/favorite/bloc/favorite_bloc.dart';
import 'package:edicion_limitada/features/favorite/service/favorite_service.dart';
import 'package:edicion_limitada/features/shopping/bloc/shopping_bloc.dart';
import 'package:edicion_limitada/features/shopping/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FC),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => FavoriteBloc(FavoriteService())..add(LoadFavoritesEvent()),
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favoriteState) {
              if (favoriteState is FavoriteLodingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (favoriteState is FavoriteErrorState) {
                return Center(child: Text(favoriteState.error));
              }

              if (favoriteState is FavoriteLoadedState) {
                if (favoriteState.favoriteIds.isEmpty) {
                  return const Center(
                    child: Text('No favorites yet!'),
                  );
                }

                return BlocBuilder<ShoppingBloc, ShoppingState>(
                  builder: (context, shoppingState) {
                    if (shoppingState is ShoppingLoaded) {
                      final favoriteProducts = shoppingState.products
                          .where((product) =>
                              favoriteState.favoriteIds.contains(product.id))
                          .toList();

                      return CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Favorites',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = favoriteProducts[index];
                                  final discountedPrice = (product.price -
                                          (product.price *
                                              (product.offer / 100)))
                                      .round();

                                  return ProductCard(
                                    product: product,
                                    discountPrice: discountedPrice,
                                  );
                                },
                                childCount: favoriteProducts.length,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}