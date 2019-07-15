import 'package:flutter/material.dart';

import 'package:expotenderos_app/components/master_scaffold.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScaffold(
      Container(
        child: Center(
          child: Text("Bienvenido ${globals.user.id} , ${globals.user.email}"),
        ),
      )
    );
  }
}