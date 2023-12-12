import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_widgets.dart';
import '../../models/booking_model.dart';
import '../../viewmodels/Report_viewmodel.dart';
import 'reportDetails_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Provider.of<ReportViewModel>(context, listen: false).getBookings();
  //   });
  // }

  Future<List<Booking>>? bookings;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(builder: (context, provider, child) {
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
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: CustomWidgets().customTextField(
                controller: provider.searchController,
                onChanged: (query) {
                  setState(() {
                    bookings = provider.search(query.trim());
                  });
                },
                labelText: 'customer name,vehicle number',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                  future:
                      provider.search(provider.searchController.text.trim()),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset(
                          "assets/loading.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: [
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
                                                              ReportDetails(
                                                                name: snapshot
                                                                    .data![
                                                                        index]
                                                                    .customername,
                                                                pNumber: snapshot
                                                                    .data![
                                                                        index]
                                                                    .customercontact,
                                                                bookingId:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                              ))).whenComplete(
                                                      () {
                                                    provider.searchController
                                                        .clear();
                                                    setState(() {
                                                      bookings = provider
                                                          .search(provider
                                                              .searchController
                                                              .text
                                                              .trim());
                                                    });
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  });
                                                },
                                                leading: Container(
                                                  height: 40,
                                                  width: 40,
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff7A77FF)
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff7A77FF),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  snapshot
                                                      .data[index].customername,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                    'Vehicle no: ${snapshot.data[index].vnum}'),
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
                    }
                    return const Center(
                      child: Text('It\'s empty here'),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
