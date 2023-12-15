import 'package:flutter/material.dart';

import '../database/db_handler.dart';
import '../models/booking_model.dart';

class ReportViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  Future<List<Booking>>? bookings;

  getBookings() {
    bookings = DBHandler().getBooking();
  }

  search(String query) {
    if (query.isEmpty) {
      return DBHandler().getBooking();
    } else {
      return DBHandler().getCustomerBasedBooking(query.trim());
    }
  }
}
