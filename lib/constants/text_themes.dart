import 'dart:developer';

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

  static final TextStyle title = GoogleFonts.libreBaskerville(
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
    // letterSpacing: 1.2,
  );

  static final TextStyle mediumSubtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle helperText = TextStyle(
    color: Colors.grey[600],
    fontSize: 12.0,
  );

  static final TextStyle title2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle actionTitle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle inputStyle = TextStyle(
    color: Colors.white,
  );

  static final TextStyle smallTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle appBar = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static final TextStyle largeSubtitle = TextStyle(
    fontSize: 18,
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

  static final accentColor = Color(0xff00838a);
  static final secondaryAccentColor = Colors.grey[500]; //Color(0xff05008a);

  static final TextStyle logout = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.redAccent,
  );

}


extension StringExtension on String {
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');


  String capitalize() {
    if(this.length == 0 || this.contains('(née'))
      return this;

    if(validCharacters.hasMatch(this[0])){
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }
    else{
      return "${this[0]}${this[1].toUpperCase()}${this.substring(2)}";
    }
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.toLowerCase().capitalize()).join(" ");
}

