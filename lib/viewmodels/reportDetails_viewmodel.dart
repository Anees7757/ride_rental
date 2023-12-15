import 'package:flutter/material.dart';

import '../database/db_handler.dart';
import '../models/booking_model.dart';
import '../models/driver_model.dart';
import '../models/expense_model.dart';
import '../models/vehicle_model.dart';

class ReportDetailsViewModel extends ChangeNotifier {
  int totalExpense = 0;
  int net = 0;
  int bookingAmount = 0;

  List<Driver> driver = [];
  List<Vehicle> vehicles = [];

  getVehicles(data) async {
    vehicles = [];
    vehicles = await DBHandler().getVehiclesWithNumber(data.first.vnum);
  }

  getDriver(data) async {
    driver = [];
    driver = await DBHandler().getDriverWithName(data.first.driver);
  }

  getData(List<Expense> exp, List<Booking> booking) {
    resetData();
    getDriver(booking);
    getVehicles(booking);
    bookingAmount = booking.first.amount;
    for (var i in exp) {
      totalExpense += i.amount;
    }
    net = totalExpense + bookingAmount;
    // notifyListeners();
  }

  resetData() {
    totalExpense = 0;
    net = 0;
    bookingAmount = 0;
    notifyListeners();
  }
}
