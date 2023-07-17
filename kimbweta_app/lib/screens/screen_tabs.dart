import 'package:flutter/material.dart';
import 'package:kimbweta_app/screens/authentication_screens/sign_in_screen.dart';
import 'package:kimbweta_app/screens/main_screens/join_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'main_screens/home_screen.dart';

class ScreenTabs extends StatefulWidget {
  static String id = '/tabs';

  const ScreenTabs({super.key});

  @override
  State<ScreenTabs> createState() => _ScreenTabsState();
}

class _ScreenTabsState extends State<ScreenTabs> {


  @override
  void initState() {
    checkLoginStatus();
    // _getUserInfo();
    //listenNotifications();
    super.initState();
  }

  checkLoginStatus() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.pushNamed(context, SignInScreen.id);
    }
  }

   int? _currentIndex = 0;

  final _tabs= [
    const HomeScreen(),
    const JoinScreen(),
    const Center(child: Text('Downloads'),),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:    _tabs[_currentIndex!],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          currentIndex: _currentIndex!,
          showUnselectedLabels: false,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.connect_without_contact),label: 'Join'),
            BottomNavigationBarItem(icon: Icon(Icons.download_sharp),label: 'Archive'),
          ],


          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),

    ) ;


  }


}




