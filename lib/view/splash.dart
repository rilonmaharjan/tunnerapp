import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tunnerapp/helper/constants.dart';
import 'package:tunnerapp/view/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller for 3 seconds
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Create a curved animation for bounce effect
    _bounceAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );

    // Create a spin animation that rotates the image as it bounces
    _spinAnimation = Tween<double>(begin: 0, end: 2 * 3.14159) // Full rotation (2π radians)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation
    _controller.forward();

    // When the animation is complete, navigate to the HomePage
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Wait for a moment and navigate to the next page
        Timer(const Duration(milliseconds: 100), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 200 * (1 - _bounceAnimation.value)),
                  child: Transform.rotate(
                    angle: _spinAnimation.value, 
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/images/logo.png", 
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
