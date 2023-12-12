import 'package:flutter/material.dart';

Widget logo() {
  return const Column(
    children: [
      Hero(
        tag: 'logo',
        child: Text(
          'Hafiz',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: -4,
            color: Color(0xff7A77FF),
          ),
        ),
      ),
      Text(
        'Travels',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
