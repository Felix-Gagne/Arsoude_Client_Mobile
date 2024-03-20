import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Design/MyClipperBackground.dart';
import 'package:untitled/Http/HttpService.dart';
import 'package:untitled/Views/Test.dart';
import 'package:untitled/Views/navBar.dart';
import '../generated/l10n.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _email = "";

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  Future<String?> getEmail() async{
    String? email = await storage.read(key: 'email');
    setState(() {
      _email = email ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double paddingUserInfo = height *0.1;
    return Scaffold(
      backgroundColor: const Color(0xFF10625F),
      body: Stack(
        children: [
          ClipPath(
              clipper: MyClipperBackground(),
              child: Container(
                color: Colors.white,
              )
          ),
          Align(
            alignment: Alignment.center,
            child:
            Padding(
              padding: EdgeInsets.only(top: paddingUserInfo),
              child: Column(
                children: [
                  SizedBox(
                    width: width *0.85,
                    child: Text(_email, style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )
                    ), textAlign: TextAlign.center),
                  ),
                  SizedBox(height: height*0.05,),
                  userImage(height, width),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          options(width, Icons.info, S.of(context).info, (){}),
                          options(width, Icons.settings, S.of(context).settings, () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage() ));
                          }),
                          options(width, Icons.collections, S.of(context).myListOfTrails, (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBar(page: 2)));
                          }),
                          options(width, Icons.bookmark, S.of(context).favorites, (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBar(page: 3)));
                          }),
                          options(width, Icons.logout, S.of(context).logout,() async{
                            await storage.delete(key: "email");
                            await storage.delete(key: "jwt");
                            if(!mounted) return;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBar(page: 1)));
                          }),
                        ],
                      )
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector options(double width, IconData icon, String optionName, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
                    padding: const EdgeInsets.all(10),
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: const Color(0xC5051717),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 4, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: const Offset(0, 3), // Offset for the shadow (vertical, horizontal)
                          ),
                        ],
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white, size: 32,),
                        SizedBox(width: width * 0.04,),
                        Text(optionName, style: GoogleFonts.plusJakartaSans(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                            )
                        ),)
                      ],
                    ),
                  ),
    );
  }

  Container userImage(double height, double width) {
    return Container(
      height: height * 0.15,
      width: width * 0.3,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Border color
          width: 2, // Border width
        ),
        borderRadius: BorderRadius.circular(45), // Adjust the value to match the container's border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 7, // Blur radius
            offset: const Offset(0, 3), // Offset for the shadow (vertical, horizontal)
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45), // Adjust the value to match the container's border radius
        child: Image.asset(
          "assets/Images/avatarPlaceHolder.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}