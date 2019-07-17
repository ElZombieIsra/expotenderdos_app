// Master styles for the app
import 'package:flutter/material.dart';

ThemeData appTheme = new ThemeData(
  primaryColor: primaryColor,
  hintColor: Colors.black45,
  fontFamily: "Raleway",
  accentColor: secondaryColor,
);

const Color primaryColor = Color.fromRGBO(0, 162, 79, 1.0);
const Color secondaryColor = Color.fromRGBO(231, 49, 76, 1.0);
const Color thirdColor = const Color.fromRGBO(16, 124, 121, 1.0);
const Color mutedColor = Colors.black38;
const Color textColor = Colors.white;

InputDecoration fieldDecoration({
  label = false,
  hint = "",
  suffixIcon,
}) => InputDecoration(
  labelText: label ? hint : null,
  hintText: !label ? hint : null,
  suffixIcon: suffixIcon,
  // border: InputBorder.none,
  contentPadding: EdgeInsets.all(15.0),
);

InputDecoration fieldDecoration2(hint) => InputDecoration(
  hintText: hint,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.zero,
    ),
    borderSide: BorderSide(
      color: Colors.black,
      width: 1.0
    )
  ),
  fillColor: Colors.white,
  filled: false,
  contentPadding: EdgeInsets.all(10.0),
  suffixIcon: Icon(
    Icons.more,
    color: Colors.black54,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.zero,
    ),
    borderSide: BorderSide(
      color: Colors.lightBlue,
    )
  )
);