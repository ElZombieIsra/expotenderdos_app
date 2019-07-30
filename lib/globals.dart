// Add global variables to use
library globals;

import 'package:flutter/material.dart';

import 'package:expotenderos_app/models/User.dart';

String title = "EXPOTENDER@";
User user;

void showSnackbar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

void showInDialog(BuildContext context, Widget child, { String title = 'Alerta', }) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
          title: Center(
            child: Text(
              "$title",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
          content: child,
        );
    }
  );
}

Msg msg;

class Msg {

  bool send = false;
  String _text;

  print(BuildContext ctx) {
    if (text != null && text.isNotEmpty) {
      showSnackbar(ctx, text);
      this.send = false;
      this.text = null;
    }
  }

  String get text => this._text;
  set text(String text) {
    this._text = text;
    this.send = true;
  }
}
