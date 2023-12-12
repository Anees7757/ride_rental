import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacementNamed(context, '/home');
    notifyListeners();
  }
}
