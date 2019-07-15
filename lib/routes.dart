import 'package:flutter/material.dart';

// Import your screens
import 'screens/HomeScreen.dart';
import 'screens/login/login_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/register/register_screen.dart';

// Give a route and link it to your screen class
Map<String, WidgetBuilder> routes = {    
  "/home": (BuildContext context) => HomeScreen(),
  "/loginScreen" : (BuildContext context) => LoginScreen(),
  "/welcomeScreen" : (BuildContext context) => WelcomeScreen(),
  "/registerShopkeeper": (BuildContext context) => RegisterScreen(),
};