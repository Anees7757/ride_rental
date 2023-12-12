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

  //   Future<void> showAddDriverDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(20.0),
  //           ),
  //         ),
  //         title: const Text('Add Expense'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CustomWidgets().customTextField(
  //                   controller: narrationController,
  //                   labelText: 'Narration',
  //                   keyboardType: TextInputType.text),
  //               CustomWidgets().customTextField(
  //                   controller: amountController,
  //                   labelText: 'Amount',
  //                   keyboardType: TextInputType.number,
  //                   textInputAction: TextInputAction.done,
  //                   ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               narrationController.clear();
  //               amountController.clear();
  //               Navigator.pop(context);
  //             },
  //             child: const Text(
  //               'Cancel',
  //               style: TextStyle(
  //                 color: Color(0xff7A77FF),
  //               ),
  //             ),
  //           ),
  //           ElevatedButton(
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateColor.resolveWith(
  //                   (states) => const Color(0xff7A77FF)),
  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                 RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(18.0),
  //                 ),
  //               ),
  //             ),
  //             onPressed: () async {
  //               if (nameController.text.isEmpty ||
  //                   phoneNumberController.text.isEmpty ||
  //                   cityController.text.isEmpty) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text('Fields can\'t be empty'),
  //                     duration: Duration(seconds: 2),
  //                     behavior: SnackBarBehavior.floating,
  //                   ),
  //                 );
  //               } else {
  //                  insertExpense(context,);
  //                       Navigator.pop(context);
  //                 int result = await DBHandler().insertDriver(newDriver);
  //                 if (result != -1) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text('Driver Added'),
  //                       duration: Duration(seconds: 2),
  //                       behavior: SnackBarBehavior.floating,
  //                     ),
  //                   );
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text('Failed to add Driver'),
  //                       duration: Duration(seconds: 2),
  //                       behavior: SnackBarBehavior.floating,
  //                     ),
  //                   );
  //                 }
  //                 Navigator.pop(context);
  //                 nameController.clear();
  //                 licenseNumberController.clear();
  //                 phoneNumberController.clear();
  //                 cityController.clear();
  //                 notifyListeners();
  //               }
  //             },
  //             child: const Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
