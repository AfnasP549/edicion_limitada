


// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:edicion_limitada/screens/shopping_screen.dart';
// import 'package:edicion_limitada/screens/favorite_screen.dart';
// import 'package:edicion_limitada/screens/home_screen.dart';
// import 'package:edicion_limitada/screens/order_screen.dart';
// import 'package:edicion_limitada/features/profile/view/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({super.key});

//   @override
//   State<CustomBottomNavigationBar> createState() => _BottomnavigationbarState();
// }

// int _currentIndex = 0;

// class _BottomnavigationbarState extends State<CustomBottomNavigationBar> {
//   List<Widget> Pages = [
//     const CustomBottomNavigationBar(),
//     FavoriteScreen(),
//     ShoppingScreen(),
//     OrderScreen(),
//     ProfileScreen(),
  
   
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CurvedNavigationBar(
//           index: _currentIndex,
//           animationDuration: const Duration(milliseconds: 200),
//           backgroundColor:  const Color.fromARGB(235, 149, 150, 151),
//           color: const Color.fromARGB(255, 251, 246, 237),
//           onTap: (value) {
//             setState(() {
//               _currentIndex = value;
//             });
//           },
//           items: const [
//             Icon(
//               FontAwesomeIcons.house,
//               color: Color.fromARGB(235, 149, 150, 151),
//             ),
//             Icon(
//               FontAwesomeIcons.heart,
//               color: Color.fromARGB(235, 149, 150, 151),
//             ),
//              Icon(
//               FontAwesomeIcons.cartShopping,
//               color: Color.fromARGB(235, 149, 150, 151),
//             ),
//              Icon(
//               FontAwesomeIcons.box,
//               color: Color.fromARGB(235, 149, 150, 151),
//             ),
             
//              Icon(
//               FontAwesomeIcons.user,
//               color: Color.fromARGB(235, 149, 150, 151),
//             ),
            
          
//           ]),
//       body: Pages[_currentIndex],
//     );
//   }
// }

import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0; // Tracks the selected tab
  final List<Widget> _pages = [
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: 
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}