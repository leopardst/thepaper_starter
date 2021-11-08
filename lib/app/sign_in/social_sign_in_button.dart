import 'package:thepaper_starter/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    Key? key,
    required IconData iconData,
    required String text,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  }) : super(
    key: key,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FaIcon(
          iconData,
          color: Colors.white,
          size: 24.0,
        ),
        SizedBox(width: 15.0,),
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 15.0),
        ),
      ],
    ),
    color: color,
    onPressed: onPressed,
    borderRadius: 18,
    height: 60,
  );
}

class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key? key,
    required String text,
    required Color color,
    required IconData iconData,
    required VoidCallback? onPressed,
    Color textColor = Colors.black87,
    double height = 60.0,
  }) : super(
    key: key,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FaIcon(
          iconData,
          color: Colors.redAccent,
          size: 24.0,
        ),
        SizedBox(width: 15.0,),
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 15.0),
        ),
      ],
    ),
    textColor: textColor,
    height: height,
    color: color,
    onPressed: onPressed,
    borderRadius: 18,
  );
  
}