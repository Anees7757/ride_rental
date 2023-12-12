import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/custom_widgets.dart';
import '../../database/db_handler.dart';
import '../../viewmodels/expense_viewmodel.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
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
              }
              provider.getCustomers(snapshot.data);

              return Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    snapshot.data.isEmpty
                        ? CustomWidgets().customTextField(
                            controller: provider.narrationController,
                            labelText: 'No Customer Found',
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
                                    hintText: 'Choose Customer',
                                  ),
                                  value: provider.cname.text,
                                  items: provider.customerNames
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    provider.cname.text = value!;
                                  }),
                            ),
                          ),
                    CustomWidgets().customTextField(
                      controller: provider.narrationController,
                      labelText: 'Naration',
                      keyboardType: TextInputType.text,
                    ),
                    CustomWidgets().customTextField(
                      controller: provider.amountController,
                      labelText: 'Amount',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 50),
                    MaterialButton(
                      onPressed: () async {
                        int result = await provider.insertExpense(context);
                        if (result != -1) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Expense Added'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Expense adding failed'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      color: const Color(0xff7A77FF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      shape: const StadiumBorder(),
                      child: const Text(
                        "Add Expense",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }
}
