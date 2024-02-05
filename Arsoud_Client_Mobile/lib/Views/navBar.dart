import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

// optional, only if using provided badge style
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';

// optional, only if using "MotionTabBarController" to programmatically change the tab
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:untitled/Views/Accueil.dart';
import 'package:untitled/Views/Suivi.dart';

import 'Login.dart';

class navBar extends StatefulWidget {
  const navBar({super.key, required this.page});

  final int page;

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> with TickerProviderStateMixin {

  MotionTabBarController? _motionTabBarController;
  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;


  void initState() {
    super.initState();

    //// Use normal tab controller
    // _tabController = TabController(
    //   initialIndex: 1,
    //   length: 4,
    //   vsync: this,
    // );

    //// use "MotionTabBarController" to replace with "TabController", if you need to programmatically change the tab
    _motionTabBarController = MotionTabBarController(
      //initialIndex: widget.page,
      initialIndex: 1,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();

    // _tabController.dispose();
    _motionTabBarController!.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        // controller: _tabController,
        controller: _motionTabBarController,
        children: <Widget>[
          HomePage(),
          HomePage(),
          HomePage(),
          HomePage(),
          Login(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Home",
        labels: const ["Search", "Home", "Navigate", "Favorite", "Profile"],
        icons: const [Icons.search, Icons.home, IconData(0xe41e, fontFamily: 'MaterialIcons'),Icons.bookmark, Icons.people_alt],

        // optional badges, length must be same with labels
        badges: [
          null,
          null,
          null,
          null,
          null,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.white,
        tabIconSize: 28.0,
        tabIconSelectedSize: 28.0,
        tabSelectedColor: Colors.green[600],
        tabIconSelectedColor: Colors.white,
        tabBarColor: const Color(0xFF10625F),
        onTabItemSelected: (int value) {
          setState(() {
            // _tabController!.index = value;
            _motionTabBarController!.index = value;
          });
        },
      ),
    );
  }
}