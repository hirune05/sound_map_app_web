import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    titleTextStyle: GoogleFonts.mPlusRounded1c(
      textStyle: const TextStyle(
        color: Styles.appBarTitleColor,
        fontSize: 25,
      ),
    ),
  );
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 59,
      height: 1.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: Styles.commonTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      height: 1.48,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: Styles.commonTextColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 17,
      height: 1.48,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: Styles.commonTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      height: 1.5,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: Styles.commonTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      height: 1.48,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: Styles.commonTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
      height: 1.57,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: Styles.commonTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      height: 1.44,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: Styles.commonTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      height: 1.5,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: Styles.commonTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      height: 1.13,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: Styles.commonTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 8,
      height: 1.48,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: Styles.commonTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 9,
      height: 1.48,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: Styles.commonTextColor,
    ),
  );
}
