import 'package:edicion_limitada/common/utils/constatns/app_color.dart';
import 'package:edicion_limitada/features/account/account_screen.dart';
import 'package:edicion_limitada/features/order/view/order_screen.dart';
import 'package:edicion_limitada/features/favorite/view/favorite_screen.dart';
import 'package:edicion_limitada/features/home_screen/view/home_screen.dart';
import 'package:edicion_limitada/features/shopping/view/shopping_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key,});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  
  int _currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    FavoriteScreen(),
    ShoppingScreen(),
    OrderScreen(),
    AccountScreen(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      //backgroundColor: Colors.white,
      body: screens[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Container(
                height: 60,
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                    color: AppColor.greyShade,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5)
                  )]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GNav(
                    gap: 8,
                    backgroundColor: AppColor.primary,
                    color: AppColor.tertiary,
                    activeColor: AppColor.tertiary,
                    tabBackgroundColor: AppColor.greyShade,
                    padding: const EdgeInsets.all(1),
                    onTabChange: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    tabs: const [
                      GButton(
                        icon: Icons.home_outlined,iconSize: 32,
                        text: 'Home',
                      ),
                        GButton(
                        icon: FontAwesomeIcons.heart,
                        text: 'Favourite',
                      ),
                      
                     
                      GButton(
                        icon: FontAwesomeIcons.compass,
                        text: 'Shopping',
                      ),
                     
                      GButton(
                        icon: FontAwesomeIcons.listCheck,
                        text: 'Order',
                      ),
                     
                      GButton(
                        icon: FontAwesomeIcons.user,
                        text: 'Account',
                      ),

                     
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
