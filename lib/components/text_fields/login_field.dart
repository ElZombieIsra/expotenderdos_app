import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {

  final String label;
  final Icon icon;
  final TextInputType keyboardType;
  final Function validator;
  final Function onSaved;
  final bool obscureText;

  LoginTextField({
    this.label,
    this.icon,
    this.keyboardType,
    this.validator,
    this.onSaved,
    this.obscureText,
  });

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {

  final Color mainColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: mainColor,
        fontFamily: "Raleway",
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: TextFormField(
          style: TextStyle(
            color: mainColor
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: widget.icon,
            // border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
          ),
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onSaved: widget.onSaved,
          obscureText: widget.obscureText ?? false,
        ),
      )
    );
  }
}