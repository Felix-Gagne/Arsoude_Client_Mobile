import 'package:flutter/material.dart';
import 'package:untitled/Http/Models.dart';

import '../Http/HttpService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final password = TextEditingController();
  final email = TextEditingController();
  bool showPassword = false;

  LoginDTO loginInfo = new LoginDTO();




  @override
  void initState(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Login title and button
              Container(
                padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){

                    }, icon: Icon(Icons.arrow_back_ios, color: Colors.black.withOpacity(0.5),), style: ButtonStyle(),),
                    SizedBox(width: 12,),
                    Text("Login", style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ), )
                  ],
                ),
              ),
              //Login Welcom title
              Container(
                padding: EdgeInsets.fromLTRB(24, 35, 168, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome Back", style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 20,),
                    Text("Sign in to your account", style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(
                            0xFFC1C1C2))),)
                  ],
                ),
              ),
              SizedBox(height: 36,),
              //connexion information
              Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email Address", style:  GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(fontSize: 14, color:  Color(0xFF868687), fontWeight: FontWeight.w500)
                      ),),
                      SizedBox(height: 16,),
                      //Email
                      SizedBox(
                        width: 320,
                        height: 48,
                        child: TextField(
                          controller: email,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0, color: Color(0xFFCDCDD2)),
                                borderRadius: BorderRadius.all(Radius.circular(36))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.5, color: Color(0xFF797575)),
                                borderRadius: BorderRadius.all(Radius.circular(36))
                            ),
                              contentPadding: EdgeInsets.all(10)

                          ),
                        ),
                      ),
                      SizedBox(height: 24,),
                      Text("Password", style:  GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(fontSize: 14, color:  Color(0xFF868687), fontWeight: FontWeight.w500)
                      )),
                      SizedBox(height: 16,),
                      //Password
                      SizedBox(
                        width: 320,
                        height: 48,
                        child: TextField(
                          obscureText: showPassword,
                          controller: password,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(

                            suffixIcon: IconButton(
                                icon: Icon(
                                    (showPassword ) ? Icons.visibility : Icons.visibility_off
                                ),
                                onPressed: (){
                                  showPassword = !showPassword;
                                  setState(() {

                                  });
                                },
                            ),

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0, color: Color(0xFFCDCDD2)),
                                borderRadius: BorderRadius.all(Radius.circular(36))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.5, color: Color(0xFF797575)),
                                borderRadius: BorderRadius.all(Radius.circular(36))
                            ),
                              contentPadding: EdgeInsets.all(10)
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,

                        ),
                      ),
                    ],
                  ),
              ),
              //Forgot button
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 35, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: (){},
                      child: Text("Forgot password?", style: GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(fontSize: 14, color:  Color(
                              0xFF09635F), fontWeight: FontWeight.bold)
                      ),)
                  ),
                ),
              ),
              //Login button
              LoginButton(),
              //Sign up section
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                            fontSize: 14, color:  Color(0xFF878788), fontWeight: FontWeight.w500
                        ))),
                    TextButton(
                        onPressed: (){},
                        child: Text("Sign up",style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                                fontSize: 14, color:  Color(0xFF09635F), fontWeight: FontWeight.bold
                            ))))
                  ],
                ),
              )
            ],
          )
    );
  }

  Padding LoginButton() {
    return Padding(
              padding: const EdgeInsets.fromLTRB(0, 26, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 327,
                  height: 56,
                  child: MaterialButton(
                    onPressed: () async{
                      try{
                        loginInfo.password = password.value.text;
                        loginInfo.username = email.value.text;
                        var request = await login(loginInfo);
                        print("Ca marche");
                      }
                      catch (e){
                        throw (e);
                      }
                    },
                    child: Text("Login", style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(fontSize: 18, color:  Colors.white, fontWeight: FontWeight.bold)
                    ),),
                    color: Color(0xFF09635F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            );
  }
}