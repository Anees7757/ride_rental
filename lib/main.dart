import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/booking_viewmodel.dart';
import 'viewmodels/driver_viewmodel.dart';
import 'viewmodels/expense_viewmodel.dart';
import 'viewmodels/reportDetails_viewmodel.dart';
import 'viewmodels/report_viewmodel.dart';
import 'viewmodels/splash_viemodel.dart';
import 'viewmodels/vehicle_viewmodel.dart';
import 'views/home_screen.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => VehicleViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DriverViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookingViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpenseViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportDetailsViewModel(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          if (FocusManager.instance.primaryFocus?.hasPrimaryFocus ?? false) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Mini Project',
          theme: ThemeData(
            useMaterial3: false,
            primaryColor: const Color(0xff7A77FF),
            indicatorColor: const Color(0xff7A77FF),
            appBarTheme: const AppBarTheme(
              color: Color(0xff7A77FF),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xff7A77FF),
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Color(0xff7A77FF),
            ),
          ),
        ),
      ),
    );
  }
}
