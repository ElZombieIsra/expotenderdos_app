// Add global variables to use
library globals;

import 'package:flutter/material.dart';

import 'package:expotenderos_app/models/User.dart';

String title = "EXPOTENDER@";
User user;

showSnackbar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
