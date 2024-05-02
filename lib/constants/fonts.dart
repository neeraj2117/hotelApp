import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFonts {
  static TextStyle primaryTextStyle({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    double lineHeight = 10,
  }) {
    return GoogleFonts.ubuntu(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      // height: lineHeight,
    );
  }

  static TextStyle secondaryTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.grey,
    double lineHeight = 10,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      // height: lineHeight,
    );
  }
}
