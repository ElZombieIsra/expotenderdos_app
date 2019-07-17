import 'package:flutter/material.dart';
import '../globals.dart' as globals;

import 'package:expotenderos_app/services/auth.dart';

class HomeScreen extends StatelessWidget {

  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    void handleButton () {
      auth.isSomeoneLoggedIn()
      .then((someone){
        if (someone != null) {
          globals.user = someone;
          Navigator.of(context).pushNamedAndRemoveUntil("/welcomeScreen", (_) => false);                    
        }
        else{
          if (globals.user != null) {
            auth.isUserLoggedIn(globals.user)
            .then((_loggedIn){
              if (_loggedIn) {
                Navigator.of(context).pushNamedAndRemoveUntil("/welcomeScreen", (_) => false);
              }
              else{
                Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (_) => false);
              }
            }).catchError((err) => print(err));
          }
          else{
            Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (_) => false);
          }
        }
      }).catchError((err) => print(err));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(globals.title),
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SizedBox.expand(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(40.0, 100.0, 40.0, 100.0),
                  child: Image.asset(
                    "assets/tendero.PNG",
                    // height: screenSize.height / 2.5,
                    // width: screenSize.width / 2,
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "Comenzar",
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                  padding: EdgeInsets.all(15.0),
                  onPressed: handleButton,
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                )
              ],
            )
          ),
        ),
      )
    );
  }

}