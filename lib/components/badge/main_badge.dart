import 'package:flutter/material.dart';

class MainBadge extends StatelessWidget {

  final String text;

  MainBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}