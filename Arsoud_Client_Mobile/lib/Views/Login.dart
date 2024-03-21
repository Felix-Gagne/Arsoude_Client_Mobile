import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Http/Models.dart';
import 'package:untitled/Views/navBar.dart';
import '../Http/HttpService.dart';
import 'package:google_fonts/google_fonts.dart';
import '../generated/l10n.dart';

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

  LoginDTO loginInfo = LoginDTO();

  loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        loginInfo.password = password.value.text;
        loginInfo.username = email.value.text;
        var request = await login(loginInfo);
        setState(() {
          wrongInformationError = "";
          loading = false;
        });
        if(!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBar(page: 1)));

      } on DioException catch (e) {
        if(!mounted) return;
        setState(() {
          loading = false;
        });

        String errorMessage = "";
        if (e.response != null) {
          if (e.response!.data["message"] ==
              "Le mot de passe ou le nom d'utilisateur ne correspond pas.") {
            errorMessage = S.of(context).PleaseCheck;
          }
          setState(() {
            wrongInformationError = errorMessage;
            S.of(context).PleaseCheck;
          });
        } else if (e.type.name == "connectionTimeout") {
          ScaffoldMessenger.of(context).showSnackBar(snackBar(S.of(context).VeuillezRessayerPlusTard));
        } else if (e.type.name == "connectionError") {
          ScaffoldMessenger.of(context).showSnackBar(snackBar(S.of(context).ReconectezInternetPourContinuer));
        }
        rethrow;
      } catch (a) {
        rethrow;
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: Row(
                  children: [
                    //BackArrow
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBar(page: 1)
                            )
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      style: const ButtonStyle(),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      S.of(context).login,
                      style: GoogleFonts.plusJakartaSans(textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              welcomeTitle(context),
              const SizedBox(height: 36,),
              informationForm(context),
              loginButton(),
              signUp(context)
            ],
          ),
        ));
  }

  Container welcomeTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 35, 168, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).welcomeBack,
            style: GoogleFonts.plusJakartaSans(textStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20,),
          Text(
            S.of(context).signInToYourAccount,
            style: GoogleFonts.plusJakartaSans(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFC1C1C2))
            ),
          )
        ],
      ),
    );
  }

  Form informationForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).emailAddress,
              style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF868687),
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 16,),
            emailInput(context),
            const SizedBox(height: 24,),
            Text(S.of(context).password, style: GoogleFonts.plusJakartaSans(
                    textStyle: const TextStyle(fontSize: 14, color: Color(0xFF868687), fontWeight: FontWeight.w500))
            ),
            const SizedBox(height: 16,),
            passwordInput(context),
            forgotPassword(context),
          ],
        ),
      ),
    );
  }

  SizedBox emailInput(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        enabled: !loading,
        validator: (email) {
          if (email == "") {
            return S.of(context).pleaseEnterAEmail;
          } else {
            return null;
          }
        },
        controller: email,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Color(0xFFCDCDD2)),
              borderRadius: BorderRadius.all(Radius.circular(36))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Color(0xFF797575)),
              borderRadius: BorderRadius.all(Radius.circular(36))),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(36)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(36)),
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Color(0xFFCDCDD2)),
              borderRadius: BorderRadius.all(Radius.circular(36))),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
      ),
    );
  }

  SizedBox passwordInput(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        enabled: !loading,
        validator: (password) {
          if (password == "") {
            return S.of(context).pleaseEnterAPassword;
          }
          return null;
        },
        obscureText: showPassword,
        controller: password,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon((showPassword) ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                showPassword = !showPassword;
                setState(() {});
              },
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Color(0xFFCDCDD2)),
                borderRadius: BorderRadius.all(Radius.circular(36))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Color(0xFF797575)),
                borderRadius: BorderRadius.all(Radius.circular(36))),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(36)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(36)),
            ),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Color(0xFFCDCDD2)),
                borderRadius: BorderRadius.all(Radius.circular(36))),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            errorText: wrongInformationError.isNotEmpty ? wrongInformationError : null),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        onChanged: (text) => setState(() => {}),
      ),
    );
  }

  Column forgotPassword(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {},
            child: Text(S.of(context).forgotPassword,
              style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(fontSize: 14, color: Color(0xFF09635F), fontWeight: FontWeight.bold)),
            )
        ),
      ],
    );
  }

  Padding signUp(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).dontHaveAnAccount,
              style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(fontSize: 14, color: Color(0xFF878788), fontWeight: FontWeight.w500))
          ),
          TextButton(
              onPressed: () {},
              child: Text(S.of(context).signUp,
                  style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(fontSize: 14, color: Color(0xFF09635F), fontWeight: FontWeight.bold))
              )
          )
        ],
      ),
    );
  }

  Padding loginButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 26, 0, 0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 327,
          height: 56,
          child: MaterialButton(
            onPressed: (loading)
                ? null
                : () async {
                    await loginUser();
                  },
            color: const Color(0xFF09635F),
            disabledColor: const Color(0xFF09635F),
            disabledTextColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: (loading)
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    S.of(context).login,
                    style: GoogleFonts.plusJakartaSans(
                        textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
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
        label: S.of(context).stop,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
}
