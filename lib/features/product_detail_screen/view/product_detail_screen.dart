// product_detail_screen.dart
import 'dart:convert';
import 'package:edicion_limitada/common/widget/cart_icon_button.dart';
import 'package:edicion_limitada/common/widget/custom_appBar.dart';
import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:edicion_limitada/features/product_detail_screen/bloc/product_detail_bloc.dart';
import 'package:edicion_limitada/features/product_detail_screen/widget/product_rating_section.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edicion_limitada/features/cart/view/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailBloc(product: product),
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final discountedPrice = (state.product.price -
                (state.product.price * (state.product.offer / 100)))
            .round();
        final bool isOutOfStock = state.product.stock <= 0;
        
        return Scaffold(
          appBar: CustomAppBar(
            title: Text(state.product.name),
            actions: const [CartIconButton()],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroProductImage(context, state),
                  const SizedBox(height: 16),
                  _buildGallery(context, state),
                  const SizedBox(height: 16),
                  _buildLimitedEditionTag(),
                  if (isOutOfStock) _buildOutOfStockBadge(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProductName(state),
                      _buildProductOffer(state),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹$discountedPrice',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${state.product.price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSpecifications(state),
                  const SizedBox(height: 16),
                  _buildAboutSection(state),
                  const SizedBox(height: 24),
                   ProductRatingsSection(productId: state.product.id),
                ],
              ),
            ),
          ),
          bottomNavigationBar: isOutOfStock 
              ? _buildOutOfStockBar() 
              : _buildBottomSection(context, state, discountedPrice),
        );
      },
    );
  }

  Widget _buildOutOfStockBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'OUT OF STOCK',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOutOfStockBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: const Text(
        'This product is currently out of stock',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeroProductImage(BuildContext context, ProductDetailState state) {
    return Hero(
      tag: 'product_image_${state.product.id}',
      child: SizedBox(
        height: 400,
        child: PageView.builder(
          controller: context.read<ProductDetailBloc>().pageController,
          itemCount: state.product.imageUrls.length,
          onPageChanged: (index) {
            context.read<ProductDetailBloc>().add(ChangeDisplayedImage(index));
          },
          itemBuilder: (context, index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: state.product.imageUrls.isNotEmpty
                    ? Image.memory(
                        base64Decode(state.product.imageUrls[index]),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.phone_iphone, size: 100);
                        },
                      )
                    : const Icon(Icons.phone_iphone, size: 100),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLimitedEditionTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'LIMITED EDITION',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildProductName(ProductDetailState state) {
    return Expanded(
      child: Text(
        state.product.name,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductOffer(ProductDetailState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${state.product.offer}% OFF',
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSpecifications(ProductDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildSpecItem(Icons.memory, 'RAM', '${state.product.ram}GB'),
        _buildSpecItem(Icons.storage, 'Storage', '${state.product.rom}GB'),
        _buildSpecItem(
            Icons.developer_board, 'Processor', state.product.processor),
        _buildSpecItem(Icons.phone_android, 'Brand', state.product.brand),
        _buildSpecItem(
            Icons.inventory, 'Stock', '${state.product.stock} units left'),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ProductDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.product.description,
          style: TextStyle(
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(BuildContext context, ProductDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gallery',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.product.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context
                      .read<ProductDetailBloc>()
                      .pageController
                      .animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.displayedImageIndex == index
                          ? Colors.blue
                          : Colors.grey[300]!,
                      width: state.displayedImageIndex == index ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.memory(
                      base64Decode(state.product.imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }



// In ProductDetailView class, update the _buildBottomSection:
Widget _buildBottomSection(
  BuildContext context,
  ProductDetailState state,
  int discountedPrice,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              Text(
                '₹$discountedPrice',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                final cartItem = cartState.items.firstWhere(
                  (item) => item.product.id == state.product.id,
                  orElse: () => CartItem(
                    product: state.product,
                    quantity: 0,
                    id: '',
                  ),
                );

                final int currentQuantityInCart = cartItem.quantity;
                final bool isInCart = currentQuantityInCart > 0;
                final bool isOutOfStock = state.product.stock <= 0;
                final bool hasReachedStockLimit = 
                    currentQuantityInCart >= state.product.stock;
                final bool canAddMore = currentQuantityInCart < state.product.stock;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOutOfStock)
                      const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else if (hasReachedStockLimit)
                      Text(
                        'Maximum stock limit (${state.product.stock}) reached',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else if (isInCart)
                      Text(
                        'Added ${currentQuantityInCart} of ${state.product.stock} available',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ElevatedButton(
                      key: ValueKey<String>('${isInCart}_${canAddMore}'),
                      onPressed: (isOutOfStock || state.isAddingToCart) 
                          ? null 
                          : () async {
                              if (!isInCart || canAddMore) {
                                // Trigger loading state
                                context.read<ProductDetailBloc>().add(
                                  AddToCartRequested(state.product),
                                );
                                
                                // Add to cart
                                context.read<CartBloc>().add(
                                  AddToCartEvent(
                                    state.product,
                                    1,
                                  ),
                                );
                                
                                // Show success popup
                               _showSuccessPopup(context);
                              } else if (hasReachedStockLimit) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartScreen(),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasReachedStockLimit ? Colors.green : null,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isAddingToCart
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(hasReachedStockLimit
                                    ? Icons.shopping_cart
                                    : FontAwesomeIcons.bagShopping),
                                const SizedBox(width: 8),
                                Text(
                                  hasReachedStockLimit 
                                      ? 'Go to Cart' 
                                      : 'Add to Cart',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


void _showSuccessPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Added to Cart!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your item has been successfully added to your cart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  // Automatically dismiss after 2 seconds
  Future.delayed(const Duration(seconds: 3), () {
    // Check if the context is still valid and the dialog is showing
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  });
}
}