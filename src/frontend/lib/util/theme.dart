import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class HotelAppTheme {
  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      headlineLarge: base.headlineLarge
          ?.copyWith(fontFamily: fontName), // headline1 -> headlineLarge
      headlineMedium: base.headlineMedium
          ?.copyWith(fontFamily: fontName), // headline2 -> headlineMedium
      headlineSmall: base.headlineSmall
          ?.copyWith(fontFamily: fontName), // headline3 -> headlineSmall
      titleLarge: base.titleLarge
          ?.copyWith(fontFamily: fontName), // headline4 -> titleLarge
      titleMedium: base.titleMedium
          ?.copyWith(fontFamily: fontName), // headline5 -> titleMedium
      titleSmall: base.titleSmall
          ?.copyWith(fontFamily: fontName), // headline6 -> titleSmall
      labelLarge: base.labelLarge
          ?.copyWith(fontFamily: fontName), // button -> labelLarge
      bodyLarge: base.bodyLarge
          ?.copyWith(fontFamily: fontName), // bodyText1 -> bodyLarge
      bodyMedium: base.bodyMedium
          ?.copyWith(fontFamily: fontName), // bodyText2 -> bodyMedium
      bodySmall: base.bodySmall
          ?.copyWith(fontFamily: fontName), // subtitle1 -> bodySmall
      labelSmall: base.labelSmall?.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData buildLightTheme() {
    final Color primaryColor = HexColor('#FF938BAE');
    final Color secondaryColor = HexColor('#FF938BAE');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      platform: TargetPlatform.iOS,
    );
  }
}
