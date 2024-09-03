import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tunnerapp/view/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child : Text("SPLASH")
      ),
    );
  }
}