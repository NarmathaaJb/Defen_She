import 'package:defenshe/pages/login_page.dart';
import 'package:defenshe/pages/signup_page.dart';
import 'package:flutter/material.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool islogin = true;

  void togglePage(){
    setState(() {
      islogin = !islogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (islogin){
      return LoginPage(onPressed: togglePage,);
    }
    else{
      return SignupPage(
        onPressed: togglePage,
      );
    }
  }
}