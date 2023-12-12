import 'package:flutter/material.dart';

import '../../database/db_handler.dart';
import 'addExpense_screen.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  String name;
  int bookingId;
  ExpenseDetailsScreen(
      {super.key, required this.name, required this.bookingId});

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xff7A77FF),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddExpenseScreen(
              //               id: widget.bookingId,
              //               name: widget.name,
              //             ))).then((value) => setState(() {}));
            },
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: DBHandler().getExpenses(widget.bookingId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  "assets/loading.gif",
                  height: 125.0,
                  width: 125.0,
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Narration',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.only(left: 0),
                                    // leading: Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   padding: const EdgeInsets.all(6),
                                    //   decoration: BoxDecoration(
                                    //     color: const Color(0xff7A77FF).withOpacity(0.1),
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   child: Center(
                                    //     child: Text(
                                    //       '${index + 1}',
                                    //       style: const TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Color(0xff7A77FF),
                                    //       ),
                                    //       //image('assets/icons/car.png'),
                                    //     ),
                                    //   ),
                                    // ),
                                    title:
                                        Text(snapshot.data![index].narration),
                                    trailing: Text(
                                        'Rs. ${snapshot.data![index].amount}'),
                                  ),
                                  index + 1 != snapshot.data!.length
                                      ? const Divider(
                                          thickness: 1,
                                          height: 0,
                                        )
                                      : const SizedBox(),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('No Expense Added yet'),
                );
              }
            }
            return const Center(
              child: Text('No Expense Added yet'),
            );
          }),
    );
  }
}
