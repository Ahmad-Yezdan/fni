import 'package:flutter/material.dart';

class MyColors {
  static const primary = Colors.blue;
  static final _lightprimary = Colors.lightBlue.shade100;
  static const white = Colors.white;
  static const black = Colors.black;
  static const scaffoldBackground = Color.fromARGB(255, 245, 245, 245);

  static Color get lightprimary => _lightprimary;
}
