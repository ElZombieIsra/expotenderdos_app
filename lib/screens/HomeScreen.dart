import 'package:flutter/material.dart';
import '../globals.dart' as globals;

import 'package:expotenderos_app/services/auth.dart';

class HomeScreen extends StatelessWidget {

  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Hello World!'),
            RaisedButton(
              child: Text('Comenzar'),
              onPressed: (){
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
              },
            )
          ],
        ),
      ),
    );
  }
}