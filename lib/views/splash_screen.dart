import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    navigate(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              logo(),
              const SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/taxi-booking-1.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
