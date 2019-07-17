// Add global variables to use
library globals;

import 'package:flutter/material.dart';

import 'package:expotenderos_app/models/User.dart';

String title = "EXPOTENDER@";
User user;

showSnackbar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
