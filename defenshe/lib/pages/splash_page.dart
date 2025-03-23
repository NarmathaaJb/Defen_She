import 'dart:async';
import 'package:defenshe/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';  // Change this to your actual home page or landing page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()), // or LoginPage()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // You can change background to your brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 300, color: Colors.pink[300],),
            const SizedBox(height: 20),
            Text(
              "DefenShe",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pink[300], // Match your app theme
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.pink[300]),
          ],
        ),
      ),
    );
  }
}
