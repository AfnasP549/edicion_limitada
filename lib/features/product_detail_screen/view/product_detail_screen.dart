import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  late int displayedImageIndex;

  @override
  void initState() {
    super.initState();
    // Initialize PageController and displayed image index
    _pageController = PageController(initialPage: 0);
    displayedImageIndex = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGalleryImageTap(int index) {
    setState(() {
      displayedImageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        (widget.product.price - (widget.product.price * (widget.product.offer / 100))).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.bagShopping, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main image display with PageView for animation
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      displayedImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
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
                        child: widget.product.imageUrls.isNotEmpty
                            ? Image.memory(
                                base64Decode(widget.product.imageUrls[index]),
                                fit: BoxFit.contain,
                              )
                            : const Icon(Icons.phone_iphone, size: 100),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Container(
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
              ),
              const SizedBox(height: 8),

              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '₹${discountedPrice}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //! Specifications
              const SizedBox(height: 16),
              const Text(
                'Specifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('RAM: ${widget.product.ram}GB'),
              Text('Storage: ${widget.product.rom}GB'),
              Text('Processor: ${widget.product.processor}'),
              Text('Brand: ${widget.product.brand}'),

              const SizedBox(height: 16),


              //!about
              Text('About', style: TextStyle(
                 fontSize: 18,
                  fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 8),
              Text('${widget.product.description}'),


              const SizedBox(height: 16),

              const Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Gallery
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.product.imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onGalleryImageTap(index),
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: displayedImageIndex == index
                                ? Colors.blue
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(widget.product.imageUrls[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Column(
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
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Icon(FontAwesomeIcons.bagShopping)
                      // const Text(
                      //   'Add To Cart',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
