import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hotels/models/hotel_Data.dart';
import 'package:hotels/view/booking_history_screen.dart';
import 'package:hotels/view/favorate_screen.dart';
import 'package:hotels/view/home_screen.dart';
import 'package:hotels/view/hotel_list.dart';
import 'package:hotels/view/profile_screen.dart';
import 'package:hotels/view/booking_screen.dart';
import 'package:hotels/view/search_screen.dart';

const Color bottomNavBgColor = Color(0xFF17203A);

class BottomNavigationBarrr extends StatefulWidget {
  const BottomNavigationBarrr({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigationBarrr> createState() => _BottomNavigationBarrrState();
}

class _BottomNavigationBarrrState extends State<BottomNavigationBarrr> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(
        currUser: FirebaseAuth.instance.currentUser!,
      ),
      SearchScreen(),
      const FavorateScreen(),
      BookingHistoryScreen(
        currUser: FirebaseAuth.instance.currentUser!,
      ),
      ProfileScreen(
        currUser: FirebaseAuth.instance.currentUser!,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 28.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.9),
            borderRadius: const BorderRadius.all(
              Radius.circular(34),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 9),
            child: GNav(
              tabBackgroundColor: Colors.grey[500]!,
              activeColor: Colors.white,
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  iconSize: 30,
                  // text: 'Home',
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.search,
                  iconSize: 30,
                  // text: 'Search',
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.favorite,
                  iconSize: 30,
                  // text: 'Favorite',
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.history,
                  iconSize: 30,
                  // text: 'Profile',
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: Icons.person,
                  iconSize: 30,
                  // text: 'Profile',
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
