import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

import 'pages/requirements/homepage.dart';

void main() => runApp(const Garage());

class Garage extends StatelessWidget {
  const Garage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garage',
      home: AnimatedSplashScreen(
        splash: Lottie.asset('assets/animation.json'),
        nextScreen: const HomePage(),
        splashIconSize: 250,
        backgroundColor: Colors.white,
        duration: 2500,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
