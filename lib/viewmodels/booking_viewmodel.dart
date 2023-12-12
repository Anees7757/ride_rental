import 'package:flutter/material.dart';

import '../database/db_handler.dart';
import '../models/booking_model.dart';
import '../models/driver_model.dart';
import '../models/vehicle_model.dart';

class BookingViewModel extends ChangeNotifier {
  List<String> vehiclesNumber = ['Choose Vehicle'];
  List<Vehicle> vehicles = [];
  List<Driver> drivers = [];
  List<String> driverItems = ['Choose Driver'];

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerContactController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController vNumController = TextEditingController();
  TextEditingController driverController = TextEditingController();

  getvehicles(List<Vehicle> data) {
    vNumController.text = vehiclesNumber[0];
    vehicles = data;
    vehiclesNumber.addAll(vehicles.map((e) => e.vehicleNo).toList());
    vehiclesNumber = vehiclesNumber.toSet().toList();
  }

  getDrivers(List<Driver> data) {
    driverController.text = driverItems[0];
    drivers = data;
    driverItems.addAll(drivers.map((e) => e.name).toList());
    driverItems = driverItems.toSet().toList();
  }

  void selectCustomer(String value) {
    vNumController.text = value;
    notifyListeners();
  }

  insertBooking(BuildContext context) async {
    if (customerNameController.text.isNotEmpty &&
        customerContactController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        vNumController.text.isNotEmpty &&
        driverController.text.isNotEmpty) {
      Booking newBooking = Booking(
        customername: customerNameController.text,
        customercontact: customerContactController.text,
        date: dateController.text,
        amount: int.parse(amountController.text),
        vnum: vNumController.text,
        driver: driverController.text,
      );

      int result = await DBHandler().insertBooking(newBooking);
      if (result != -1) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking Done'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        customerNameController.clear();
        customerContactController.clear();
        dateController.clear();
        amountController.clear();
        vNumController.clear();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking Failed'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields must be filled!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    notifyListeners();
  }
}
