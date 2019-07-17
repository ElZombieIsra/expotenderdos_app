import 'package:expotenderos_app/components/buttons/main_button.dart';
import 'package:expotenderos_app/components/text_fields/login_field.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.title),
      ),
      body: Builder(
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox.expand(
                  child: Form(
                    key: formKey,
                    autovalidate: autovalidate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Ingresa tus datos para iniciar sesión",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 60.0,
                        ),
                        LoginTextField(
                            label: "Correo",
                            icon: Icon(Icons.mail_outline),
                            validator: validations.validateEmail,
                            onSaved: (val) => user.email = val,
                            keyboardType: TextInputType.emailAddress,
                        ),
                        LoginTextField(
                            label: "Contraseña",
                            icon: Icon(Icons.lock_open),
                            validator: validations.validatePassword,
                            onSaved: (val) => user.password = val,
                            obscureText: true,
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
                                Navigator.of(context).pushNamedAndRemoveUntil('/welcomeScreen', (_) => false);
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
            )
          );
        },
      )
    );
  }
}