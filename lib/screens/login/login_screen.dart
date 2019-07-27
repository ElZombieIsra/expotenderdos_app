import 'package:expotenderos_app/components/buttons/main_button.dart';
import 'package:expotenderos_app/components/text_fields/login_field.dart';
import 'package:expotenderos_app/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:expotenderos_app/globals.dart' as globals;
import 'package:expotenderos_app/services/validations.dart';
import 'package:expotenderos_app/screens/Login/login_presenter.dart';

import 'package:expotenderos_app/models/User.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  bool autovalidate = false;
  Validations validations = Validations();
  User user = User();
  LoginPresenter presenter = LoginPresenter();
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {

    // ScrollController _scrollController = ScrollController();
    final Size screenSize = MediaQuery.of(context).size;

    // Middleware that redirects if someone is logged in
    auth.isSomeoneLoggedIn()
    .then((someone){
      if (someone != null) {
        globals.user = someone;
        Navigator.of(context).pushNamedAndRemoveUntil("/syncScreen", (_) => false);                    
      }
      else{
        if (globals.user != null) {
          auth.isUserLoggedIn(globals.user)
          .then((_loggedIn){
            if (_loggedIn) {
              Navigator.of(context).pushNamedAndRemoveUntil("/syncScreen", (_) => false);
            }
          }).catchError((err) => print(err));
        }
      }
    }).catchError((err) => print(err));

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(globals.title),
      // ),
      body: Builder(
        builder: (BuildContext ctx) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: <Widget>[
                Container(
                  height: screenSize.height - 10,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        autovalidate: autovalidate,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Image.asset(
                                "assets/tendero.PNG",
                                height: screenSize.height / 3,
                              ),
                            ),
                            // Text(
                            //   "Ingresa tus datos para iniciar sesión",
                            //   style: TextStyle(
                            //     fontSize: 30.0,
                            //     fontWeight: FontWeight.w500,
                            //     color: Colors.white
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                            // Container(
                            //   height: 30.0,
                            // ),
                            LoginTextField(
                                label: "Usuario",
                                icon: Icon(Icons.mail_outline),
                                validator: validations.validateUsername,
                                onSaved: (val) => user.username = val,
                                keyboardType: TextInputType.text,
                            ),
                            LoginTextField(
                                label: "Contraseña",
                                icon: Icon(Icons.lock_open),
                                validator: validations.validatePassword,
                                onSaved: (val) => user.password = val,
                                obscureText: true,
                            ),
                            Container(
                              height: 20.0,
                            ),
                            MainButton(
                              text: "Iniciar sesión", 
                              fun: (){
                                presenter.submit(
                                  ctx: ctx,
                                  form: formKey.currentState,
                                  user: user,
                                ).then((_user){
                                  if (_user != null) {
                                    globals.user = _user;
                                    Navigator.of(context).pushNamedAndRemoveUntil('/syncScreen', (_) => false);
                                  }
                                  else{
                                    autovalidate = true;
                                  }
                                });
                              },
                            ),
                            // RaisedButton(
                            //   child: Text("Borrar tabla (DEV only)"),
                            //   onPressed: (){
                            //     presenter.delete();
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}

