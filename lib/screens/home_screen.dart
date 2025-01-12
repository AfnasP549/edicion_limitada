import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/pages/login_screen.dart';
import 'package:edicion_limitada/screens/home_model.dart';
import 'package:edicion_limitada/features/profile/view/profile_screen.dart';
import 'package:edicion_limitada/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //! List of products
    final List<Product> products = [
      Product(
        name: 'Poco F2',
        price: '₹1,25,999',
        imagePath: 'image/POCO-Deadpool-Edition.jpg',
        discount: '25% off',
      ),
      Product(
        name: 'Nothing Phone',
        price: '₹45,999',
        imagePath: 'image/nothiong.jpeg',
        discount: '10% off',
      ),
    ];

    //! Images for carousel
    final List<String> imagePaths = [
      'image/POCO-Deadpool-Edition.jpg',
      'image/nothiong.jpeg',
    ];

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
            IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.bell)),
            IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.cartPlus)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()));
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
              return const Center(child: CircularProgressIndicator());
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: const Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child:  Row(
                            children: [
                              Icon(Icons.search,color: Colors.grey,),
                              Text('Explore Limited Editions...',style: TextStyle(color: Colors.grey),),
                            ],
                          ),
                        )),
                      ),
                    ),
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: 'Explore Limited Editions...',
                    //     prefixIcon: const Icon(Icons.search),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.grey,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    CarouselSlider(
                      items: imagePaths
                          .map((path) => ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  path,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: 200,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Top Product',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See all',
                                style: TextStyle(
                                    color:
                                        Color.fromARGB(235, 91, 158, 225),
                                    fontSize: 18),
                              ))
                        ],
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(product.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          product.price,
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            product.discount,
                                            style: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
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
          },
        ),
      ),
    );
  }
}
