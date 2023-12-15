import 'package:flutter/material.dart';
import '../database/db_handler.dart';
import '../models/booking_model.dart';
import '../models/expense_model.dart';

class ExpenseViewModel extends ChangeNotifier {
  List<String> customerNames = ['Choose Customer'];
  List<Booking> bookings = [];

  TextEditingController cname = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  getCustomers(var data) {
    cname.text = customerNames[0];
    bookings = data;
    customerNames.addAll(bookings.map((e) => e.customername).toList());
    customerNames = customerNames.toSet().toList();
  }

  void selectCustomer(String value) {
    cname.text = value;
    notifyListeners();
  }

  Future<int> insertExpense(BuildContext context) async {
    int bookingid = bookings
        .where((element) => element.customername == cname.text)
        .first
        .id!;

    Expense newExp = Expense(
      bookingid: bookingid,
      narration: narrationController.text,
      amount: int.parse(amountController.text),
    );
    int rowId = await DBHandler().insertExpense(newExp);
    cname.clear();
    narrationController.clear();
    amountController.clear();
    notifyListeners();
    return rowId;
  }
}
