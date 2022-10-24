import 'package:flutter/material.dart';
import 'package:notemaker/configs/config.dart';
import 'package:notemaker/screens/home_screen.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (NoteMakerApp.auth.currentUser != null) {
        print(NoteMakerApp.auth.currentUser!.displayName);
        print(NoteMakerApp.auth.currentUser!.phoneNumber);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/background.png'),
          Center(
              child: Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.26),
            child: Image.asset('assets/Group 468.png'),
          )),
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.06),
            child: titleWidget(Colors.white),
          )),
        ],
      ),
    );
  }
}
