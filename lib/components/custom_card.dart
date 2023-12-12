import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String route;

  CustomCard({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(top: 2, bottom: 2),
        child: Card(
          color: Colors.blue.shade100,
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
