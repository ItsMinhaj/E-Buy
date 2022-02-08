import 'package:e_commerce/const/app_color.dart';
import 'package:e_commerce/screens/add_to_cart/add_to_cart.dart';
import 'package:e_commerce/screens/add_to_favorite/add_to_favorite.dart';
import 'package:e_commerce/screens/home/home.dart';
import 'package:e_commerce/screens/user_profile/user_profile.dart';
import 'package:flutter/material.dart';

class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({Key? key}) : super(key: key);

  @override
  State<BottomNavigationController> createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  int _selectedIndex = 0;

  final _pages = const [
    HomeScreen(),
    FavoritScreen(),
    AddToCartScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "person",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.secondaryColor,
        unselectedItemColor: Colors.black45,
        iconSize: 36,
        elevation: 5,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: Center(child: _pages[_selectedIndex]),
    );
  }
}
