import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

// optional, only if using provided badge style
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';

// optional, only if using "MotionTabBarController" to programmatically change the tab
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:untitled/Views/Accueil.dart';
import 'package:untitled/Views/FavoriteTrails.dart';
import 'package:untitled/Views/Suivi.dart';
import 'package:untitled/Views/UserTrails.dart';

import '../Http/HttpService.dart';
import '../generated/l10n.dart';
import 'Login.dart';
import 'Profile.dart';

class navBar extends StatefulWidget {
  const navBar({super.key, required this.page});

  final int page;


  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> with TickerProviderStateMixin {

  MotionTabBarController? _motionTabBarController;
  int _initialTabIndex = 0;


  String _email = "";
  String _user = "";

  Future<String?> getEmail() async{
    String? email = await storage.read(key: 'email');
    String? user = await storage.read(key: 'jwt');
    setState(() {
      _email = email ?? "";
      _user = user ?? "";
    });
  }

  void initState() {
    super.initState();
    getEmail();
    _initialTabIndex = widget.page;
    _motionTabBarController = MotionTabBarController(
      initialIndex: _initialTabIndex,
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
    List<String> labels = [S.of(context).search, S.of(context).home, S.of(context).myTrails, S.of(context).favorite, S.of(context).profile];

    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        // controller: _tabController,
        controller: _motionTabBarController,
        children: <Widget>[
          HomePage(),
          HomePage(),
          UserTrails(),
          FavoritTerails(),
          Profile(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: labels[widget.page],
        labels: labels,
        icons: const [Icons.search, Icons.home, Icons.collections,Icons.bookmark, Icons.people_alt],
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
            if(value != 1 && value != 0 && _user == null || _user == ""){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text(S.of(context).advertisement),
                      content: Text(S.of(context).youNeedToBeLoggedInToAccessThisPage),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            // Navigate to the login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text('Login'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            // Navigate to the login page
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => navBar(page: 1))
                            );
                          },
                          child: Text(S.of(context).cancel),
                        ),
                      ],
                    );
                  }
              );
            }
            else{
              print(_user);
              _motionTabBarController!.index = value;
            }
          });
        },
      ),
    );
  }
}