import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';

class HomeNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const HomeNavigation(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Theme.of(context).colorScheme.lightGrey1,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/nav_calendar.svg",
              height: 20,
            ),
            activeIcon: SvgPicture.asset(
              "assets/nav_calendar.svg",
              color: Colors.black,
              height: 20,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/nav_shopping.svg",
              height: 20,
            ),
            activeIcon: SvgPicture.asset(
              "assets/nav_shopping.svg",
              color: Colors.black,
              height: 20,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/nav_profile.svg",
              height: 20,
            ),
            activeIcon: SvgPicture.asset(
              "assets/nav_profile.svg",
              color: Colors.black,
              height: 20,
            ),
            label: ""),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
