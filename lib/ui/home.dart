import 'package:flutter/material.dart';
import 'package:fun_fam/ui/home/shopping_screen.dart';
import 'package:fun_fam/ui/my_page/my_page.dart';
import 'package:fun_fam/ui/scehdule/schedule_home.dart';

import 'home/home_header.dart';
import 'home/home_navigation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [HomeHeader(), Expanded(child: ScheduleHome())],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [HomeHeader(), Expanded(child: ShoppingScreen())],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [Expanded(child: MyPage())],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle bottomLabelStyle =
        Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // actions: [Image.asset("assets/ic_noti.png")],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: HomeNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
