import 'package:flutter/material.dart';
import 'package:star_wars/db/people_database.dart';
import 'package:star_wars/ui/favorite.dart';
import 'package:star_wars/ui/people.dart';
import 'package:star_wars/ui/profile.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    PeopleDatabase.instance.database;
  }

  @override
  void dispose() {
    PeopleDatabase.instance.close();

    super.dispose();
  }

  List<Widget> _widgetOptions = <Widget>[
    PeoplePage(),
    FavoritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.grey,
            ),
            label: 'HOME',
            activeIcon: Icon(
              Icons.home_filled,
              color: Colors.lightBlue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline,
              color: Colors.grey,
            ),
            label: 'FAVORITE',
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.lightBlue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
              color: Colors.grey,
            ),
            label: 'PROFILE',
            activeIcon: Icon(
              Icons.person,
              color: Colors.lightBlue,
            ),
          ),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}