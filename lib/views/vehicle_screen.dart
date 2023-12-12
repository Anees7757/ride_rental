import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/db_handler.dart';
import '../viewmodels/vehicle_viewmodel.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleViewModel>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Hero(
            tag: 'logo',
            child: Text(
              'Hafiz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: -4,
                color: Color(0xff7A77FF),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () => provider.showAddVehicleDialog(context),
              icon: const Icon(
                Icons.add_box_rounded,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: DBHandler().getVehicles(),
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
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Vehicle No: ${snapshot.data[index].vehicleNo}'),
                                      Text(
                                          'Model: ${snapshot.data[index].model}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Image.asset(
                                      'assets/icons/delete.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    onPressed: () async {
                                      int result = await DBHandler()
                                          .deleteVehicle(
                                              snapshot.data[index].name);
                                      if (result != -1) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Vehicle Deleted'),
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to delete Vehicle'),
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                      setState(() {});
                                    },
                                  )),
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
                  );
                } else {
                  return const Center(
                    child: Text('No Vehicle'),
                  );
                }
              }
              return const Center(
                child: Text('No Vehicle'),
              );
            }),
      );
    });
  }
}
