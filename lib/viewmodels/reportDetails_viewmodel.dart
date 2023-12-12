import 'package:flutter/material.dart';

import '../database/db_handler.dart';
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

  getTotalExpense(List<Expense> data) {
    totalExpense = 0;
    net = 0;
    for (var i in data) {
      totalExpense += i.amount;
    }
    net = totalExpense + bookingAmount;
  }
}
