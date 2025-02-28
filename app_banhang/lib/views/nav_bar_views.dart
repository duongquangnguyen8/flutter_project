import 'package:app_banhang/views/favorite_views.dart';
import 'package:app_banhang/views/home_views.dart';
import 'package:app_banhang/views/profile_views.dart';
import 'package:app_banhang/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

class NavBarViews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavBarViewsState();
}

class _NavBarViewsState extends State<NavBarViews> {
  int currentIndex = 0;
  List views = [
    HomeViews(),
    FavoriteViews(),
    Scaffold(),
    ProfileViews(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppbar(),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedIndex: currentIndex,
        indicatorColor: const Color.fromARGB(255, 185, 185, 182),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite,
              size: 30,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.notifications,
              size: 30,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: '',
          ),
        ],
      ),
      body: views[currentIndex],
    );
  }
}
