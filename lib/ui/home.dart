import 'package:flutter/material.dart';
import 'package:fun_fam/ui/home/home_navigation.dart';
import 'package:fun_fam/ui/home/profile_screen.dart';
import 'package:fun_fam/ui/home/shopping_screen.dart';
import 'package:fun_fam/ui/scehdule/schedule_home.dart';

import 'home/home_header.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [Expanded(child: ProfileScreen())],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [HomeHeader(), Expanded(child: ScheduleHome())],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [HomeHeader(), Expanded(child: ShoppingScreen())],
    )
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle bottomLabelStyle =
        Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [Image.asset("assets/ic_noti.png")],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      //
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     if (_selectedIndex > 0) HomeHeader(),
      //     Expanded(child: _widgetOptions.elementAt(_selectedIndex))
      //   ],
      // ),
      bottomNavigationBar: HomeNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
