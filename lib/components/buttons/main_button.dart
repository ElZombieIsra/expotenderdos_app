import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {

  final String text;
  final Function fun;

  MainButton({
    @required this.text,
    this.fun
  });

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 16.0
        ),
      ),
      padding: EdgeInsets.all(15.0),
      onPressed: widget.fun ?? (){},
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
    );
  }
}