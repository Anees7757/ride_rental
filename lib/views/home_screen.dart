import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'booking_screen.dart';
import 'driver_screen.dart';
import 'expense/addExpense_screen.dart';
import 'report/report_screen.dart';
import 'vehicle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<String> bottomNavBarLabels = [
    'Vehicles',
    'Drivers',
    'Booking',
    'Expense',
    'Report',
  ];

  List<Widget> pageLists = const [
    VehicleScreen(),
    DriverScreen(),
    Booking(),
    AddExpenseScreen(),
    ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: pageLists.elementAt(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex = 2;
          });
        },
        child: image('assets/icons/booking_filled.png'),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 10,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (v) {
              setState(() {
                currentIndex = v;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xff7A77FF),
            selectedLabelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            items: [
              BottomNavigationBarItem(
                label: bottomNavBarLabels.elementAt(0),
                icon: image('assets/icons/car.png'),
                activeIcon: image('assets/icons/car_filled.png'),
              ),
              BottomNavigationBarItem(
                label: bottomNavBarLabels.elementAt(1),
                icon: image('assets/icons/driver.png'),
                activeIcon: image('assets/icons/driver_filled.png'),
              ),
              const BottomNavigationBarItem(
                label: '',
                icon: SizedBox(),
              ),
              BottomNavigationBarItem(
                label: bottomNavBarLabels.elementAt(3),
                icon: image('assets/icons/exp.png'),
                activeIcon: image('assets/icons/exp_filled.png'),
              ),
              BottomNavigationBarItem(
                label: bottomNavBarLabels.elementAt(4),
                icon: image('assets/icons/report.png'),
                activeIcon: image('assets/icons/report_filled.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget image(String path) {
  return Image.asset(
    path,
    height: 32,
    width: 32,
  );
}
