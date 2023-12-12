import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_widgets.dart';
import '../../database/db_handler.dart';
import '../../viewmodels/Report_viewmodel.dart';
import 'expenseDetails_screen.dart';
import 'expenseSearch_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(builder: (context, provider, child) {
      return Scaffold(
        //backgroundColor: Colors.white,
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
            future: DBHandler().getBooking(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset(
                    "assets/loading.gif",
                    height: 125.0,
                    width: 125.0,
                  ),
                );
              } else if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ExpenseSearch()));
                        },
                        child: CustomWidgets().customTextField(
                          controller: provider.searchController,
                          labelText: 'Search...',
                          //'Search by name/number'
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      (snapshot.data.isNotEmpty)
                          ? Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExpenseDetailsScreen(
                                                          name: snapshot
                                                              .data[index]
                                                              .customername,
                                                          bookingId: snapshot
                                                              .data[index]
                                                              .id)));
                                        },
                                        leading: Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff7A77FF)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff7A77FF),
                                              ),
                                              //image('assets/icons/car.png'),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data[index].customername,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        //subtitle:
                                        //  Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text(
                                        //         '${snapshot.data[index].amount}'),
                                        //     Text(
                                        //         'Vehicle No: ${snapshot.data[index].date}'),
                                        //   ],
                                        // ),
                                      ),
                                      index + 1 != snapshot.data!.length
                                          ? const Divider(
                                              thickness: 1,
                                            )
                                          : const SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Text('It\'s empty here'),
                            ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text('It\'s empty here'),
              );
            }),
      );
    });
  }
}
