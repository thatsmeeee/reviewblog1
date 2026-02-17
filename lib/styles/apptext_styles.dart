import 'package:flutter/material.dart';

//to store font families, font sizes, font weights, and TextStyle objects.
class AppTextStyles {
  static const String fontFamily = 'Arial';

  // General Header default
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  // General body default
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  // login page area
  static const TextStyle logintitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // login header
  static const TextStyle loginheader = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 109, 199, 241),
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  //login error style
  static const TextStyle loginerror = TextStyle(color: Colors.red);
}
