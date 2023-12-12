import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/custom_widgets.dart';
import '../database/db_handler.dart';
import '../viewmodels/booking_viewmodel.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Hafiz',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              letterSpacing: -4,
              color: Color(0xff7A77FF),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: FutureBuilder(
            future: Future.wait(
                [DBHandler().getDrivers(), DBHandler().getVehicles()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset(
                    "assets/loading.gif",
                    height: 125.0,
                    width: 125.0,
                  ),
                );
              }

              provider.getDrivers(snapshot.data[0]);
              provider.getvehicles(snapshot.data[1]);

              return Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      CustomWidgets().customTextField(
                        controller: provider.customerNameController,
                        labelText: 'Customer Name',
                        keyboardType: TextInputType.text,
                      ),
                      CustomWidgets().customTextField(
                        controller: provider.customerContactController,
                        labelText: 'Customer Contact',
                        keyboardType: TextInputType.number,
                      ),
                      snapshot.data[0].isEmpty
                          ? CustomWidgets().customTextField(
                              controller: provider.vNumController,
                              labelText: 'No Driver Found',
                              readOnly: true)
                          : Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    hintText: provider.driverItems[0],
                                  ),
                                  value: provider.driverController.text,
                                  items: provider.driverItems
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    provider.driverController.text =
                                        value.toString();
                                  },
                                ),
                              ),
                            ),
                      snapshot.data[1].isEmpty
                          ? CustomWidgets().customTextField(
                              controller: provider.vNumController,
                              labelText: 'No Vehicle Found',
                              readOnly: true)
                          : Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      hintText: 'Choose Vehicle',
                                    ),
                                    value: provider.vNumController.text,
                                    items: provider.vehiclesNumber
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      provider.vNumController.text =
                                          value.toString();
                                    }),
                              ),
                            ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          CustomWidgets().customTextField(
                            controller: provider.dateController,
                            labelText: 'Date',
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 320,
                                              child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  onDateTimeChanged: (newDate) {
                                                    // setState(() {

                                                    // });
                                                    provider.dateController
                                                            .text =
                                                        '${newDate.day}/${newDate.month}/${newDate.year}';
                                                  }),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    provider.dateController
                                                        .clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Color(0xff7A77FF),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateColor
                                                            .resolveWith((states) =>
                                                                const Color(
                                                                    0xff7A77FF)),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                      CustomWidgets().customTextField(
                          controller: provider.amountController,
                          labelText: 'Amount',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done),
                      const SizedBox(height: 50),
                      MaterialButton(
                        onPressed: () {
                          provider.insertBooking(context);
                        },
                        color: const Color(0xff7A77FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        shape: const StadiumBorder(),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }
}
