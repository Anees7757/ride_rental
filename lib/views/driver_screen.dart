import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/db_handler.dart';
import '../viewmodels/driver_viewmodel.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DriverViewModel>(builder: (context, provider, child) {
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
          actions: [
            IconButton(
              onPressed: () => provider.showAddDriverDialog(context),
              icon: const Icon(
                Icons.add_box_rounded,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: DBHandler().getDrivers(),
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
                if (snapshot.data.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  // padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7A77FF)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(
                                        File.fromUri(Uri.parse(
                                            snapshot.data[index].image)),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Phone No: ${snapshot.data[index].phoneNumber}'),
                                    (snapshot.data[index].licenseNumber == null)
                                        ? const Text(
                                            'License No: Not available')
                                        : Text(
                                            'License No: ${snapshot.data[index].licenseNumber}'),
                                    Text('City: ${snapshot.data[index].city}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Image.asset(
                                    'assets/icons/delete.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  onPressed: () async {
                                    int result = await DBHandler().deleteDriver(
                                        snapshot.data[index].name);
                                    if (result != -1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Driver Deleted'),
                                          duration: Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Failed to delete Driver'),
                                          duration: Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                    // provider.getDrivers();
                                    setState(() {});
                                  },
                                )),
                            index + 1 != snapshot.data!.length
                                ? const Divider(
                                    thickness: 1,
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No Driver'),
                  );
                }
              }
              return const Center(
                child: Text('No Driver'),
              );
            }),
      );
    });
  }
}
