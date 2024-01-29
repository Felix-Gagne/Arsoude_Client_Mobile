import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(
        child: Column(
          children: [
            SearchBar(),
          ],
        ),
      )
    );
  }

}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.left,

          decoration: InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            prefixIcon: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Image.network('C:\Users\2184803\Desktop\Arsoude_Client_Mobile\Arsoud_Client_Mobile\lib\Images\image 2.png', height: 30, width: 30,),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
          ),

        ),

      ],
    );
  }
}