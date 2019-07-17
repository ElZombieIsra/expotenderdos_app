import 'package:flutter/material.dart';
import 'routes.dart';
import 'style.dart';
import 'screens/HomeScreen.dart';
import 'globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "${globals.title}",
      theme: appTheme,
      home: HomeScreen(),
      routes: routes,
    );
  }
}