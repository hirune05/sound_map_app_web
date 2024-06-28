import 'package:flutter/material.dart';

//abstract class→継承されることを前提として、処理内容を記述しないメソッド（抽象メソッド）を含むクラス
abstract class Styles {
  static const int _primaryValue = 0xFF2c4671;
  static const MaterialColor primarySwatch = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(_primaryValue),
      100: Color(_primaryValue),
      200: Color(_primaryValue),
      300: Color(_primaryValue),
      400: Color(_primaryValue),
      500: Color(_primaryValue),
      600: Color(_primaryValue),
      700: Color(_primaryValue),
      800: Color(_primaryValue),
      900: Color(_primaryValue),
    },
  );
  static const Color primaryColor = Color(0xFF2c4671);
  static const Color primaryColor700 = Color(0xFFFFFCF0);
  static const Color accentColor = Color(0xFFf1f7d9);
  static const Color myButtonColor = Color.fromARGB(255, 253, 234, 234);
  static const Color secondaryColor = Color(0xFF808080);
  static const Color secondaryColor900 = Color.fromARGB(130, 89, 74, 49);
  static const Color pageBackground = Color(0xFFFFFCF0);
  static const Color appBarTitleColor = pageBackground;
  static const Color commonTextColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color.fromARGB(255, 154, 24, 24);
  static AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: Styles.primaryColor,
    iconTheme: const IconThemeData(
      color: Styles.appBarTitleColor,
    ),
  );
}
