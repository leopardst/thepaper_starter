import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class TextThemes {

  static final TextStyle login1 = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );

    static final TextStyle logo = GoogleFonts.notoSerif(
        fontWeight: FontWeight.w600,
        fontSize: 32.0
  );

  static final TextStyle title = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static final TextStyle title2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle actionTitle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle smallTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle smallSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );


  static final TextStyle body1 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
  );

  static final TextStyle dateStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.green[900],
  );

  static final TextStyle commentBody = TextStyle(
    height: 1.45, 
  );

  static final TextStyle helperText = TextStyle(
    color: Colors.grey[600],
  );

  static final TextStyle logout = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.redAccent,
  );

}