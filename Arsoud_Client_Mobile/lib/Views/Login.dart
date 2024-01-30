import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Http/Models.dart';
import 'package:untitled/Views/Accueil.dart';
import 'package:untitled/Views/navBar.dart';

import '../Http/HttpService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Login extends StatefulWidget {
  const Login({super.key});



  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final password = TextEditingController();
  final email = TextEditingController();
  String wrongInformationError = "";
  bool showPassword = false;
  bool loading = false;

  LoginDTO loginInfo = new LoginDTO();


  final _formKey = GlobalKey<FormState>();


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
        SingleChildScrollView(
          child: Column(
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
              Form(
                key: _formKey,
                child: Padding(
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
                        //height: 48,
                        child: TextFormField(
                          validator: (email){
                            if(email == ""){
                              return "Please enter a email";
                            }
                            else{
                              return null;
                            }
                          },
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Colors.red), // Customize error border color here
                              borderRadius: BorderRadius.all(Radius.circular(36)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Colors.red), // Same as error border for consistency
                              borderRadius: BorderRadius.all(Radius.circular(36)),
                            ),
          
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                        //height: 48,
                        child: TextFormField(
                          validator: (password){
                            if(password == ""){
                              return "Please enter a password";
                            }
                            return null;
                          },
                          obscureText: showPassword,
                          controller: password,
                          textAlignVertical: TextAlignVertical.center,
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
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.5, color: Colors.red), // Customize error border color here
                                borderRadius: BorderRadius.all(Radius.circular(36)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.5, color: Colors.red), // Same as error border for consistency
                                borderRadius: BorderRadius.all(Radius.circular(36)),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              errorText: wrongInformationError.isNotEmpty ? wrongInformationError : null
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          onChanged: (text) => setState(() => {}),
                        ),
                      ),
                    ],
                  ),
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
          ),
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
              if(_formKey.currentState!.validate()){
                try{
                  setState(() {
                    loading = true;
                  });
                  loginInfo.password = password.value.text;
                  loginInfo.username = email.value.text;
                  var request = await login(loginInfo);
                  print("Ca marche");
                  setState(() {
                    wrongInformationError = "";
                    loading = false;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const navBar(page: 0)));
                }
                on DioException catch (e){
                  setState(() {
                    loading = false;
                  });
                  var errorMessage;
                  if(e.response != null){
                    if(e.response!.data["message"] == "Le mot de passe ou le nom d'utilisateur ne correspond pas."){
                      errorMessage = "Please verify you Password and your Email Address";
                    }
                    setState(() {
                      wrongInformationError = errorMessage;
                      "Please verify your Email Address and Password";
                    });
                  }
                  else if(e.type.name == "connectionTimeout"){
                    ScaffoldMessenger.of(context).showSnackBar(snackBar('Nos serveurs rencontre actuellement un probléme. Veuillez réesayer plus tard'));
                  }
                  else if(e.type.name == "connectionError"){
                    ScaffoldMessenger.of(context).showSnackBar(snackBar('Veuillez vous reconectez internet pour continuer.'));
                  }
                  throw (e);
                }
                catch (a){
                  print(a);
                  throw(a);
                }
              }
            },
            child: (loading) ? CircularProgressIndicator() :
            Text("Login", style: GoogleFonts.plusJakartaSans(
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

  SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Stop',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
}