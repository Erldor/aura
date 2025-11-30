
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  static late Color mainTextColor;
  static late Color bottomNavigationColor;
  static late Color mainYellowColor;
  static late Color buttonGreyColor;
  static late Color mainGreyColor;
  static late Color appBarColor;
  static late Color chatGreyColor;

  static ThemeData darkTheme()
  {
    mainTextColor = const Color.fromARGB(255, 233, 233, 233);
    mainGreyColor = const Color.fromARGB(255, 20, 20, 20);
    bottomNavigationColor = const Color.fromARGB(255, 55, 55, 55);
    buttonGreyColor = const Color.fromARGB(255, 91, 91, 91);
    appBarColor = const Color.fromARGB(255, 33, 33, 33);
    mainYellowColor = const Color.fromARGB(255, 255, 250, 184);
    chatGreyColor = const Color.fromARGB(255, 169, 169, 169);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: mainGreyColor,
      appBarTheme: AppBarTheme(backgroundColor: appBarColor),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: mainTextColor,
        displayColor: mainTextColor,
        decoration: TextDecoration.none,
        fontFamily: "Montserrat",
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
        foregroundColor: buttonGreyColor, // цвет текста
        backgroundColor: mainYellowColor,   // цвет кнопки
      ),),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: mainYellowColor
      ),
      drawerTheme: DrawerThemeData(backgroundColor: appBarColor)
    );
  }
}