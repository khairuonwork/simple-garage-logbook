import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'homepage.dart'; // Replace with your actual main page

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/animation.json'),
      nextScreen: const HomePage(),
      splashIconSize: 250,
      backgroundColor: Colors.white,
      duration: 2500,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 800),
    );
  }
}
