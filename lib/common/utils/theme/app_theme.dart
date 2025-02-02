import 'package:edicion_limitada/common/utils/theme/custome_theme/elevatedButton_theme.dart';
import 'package:edicion_limitada/common/utils/theme/custome_theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: CtextTheme.lightTextTheme,
    elevatedButtonTheme: CElevatedbuttonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
     useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: CtextTheme.darkTextTheme,
    elevatedButtonTheme: CElevatedbuttonTheme.darkElevatedButtonTheme,

  );
}