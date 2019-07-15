import 'package:flutter/material.dart';

import 'package:expotenderos_app/globals.dart' as globals;
import 'package:expotenderos_app/style.dart';
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
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: (screenSize.height / 5)*3,
                  child: Form(
                    key: formKey,
                    autovalidate: autovalidate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: fieldDecoration(
                            hint: 'Correo',
                            suffixIcon: Icon(Icons.mail_outline),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: validations.validateEmail,
                          onSaved: (val) => user.email = val,
                        ),
                        TextFormField(
                          decoration: fieldDecoration(
                            hint: 'Contraseña',
                            suffixIcon: Icon(Icons.lock_open),
                          ),
                          obscureText: true,
                          validator: validations.validatePassword,
                          onSaved: (val) => user.password = val,
                        ),
                        RaisedButton(
                          child: Text("Iniciar sesión"),
                          onPressed: (){
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
                        RaisedButton(
                          child: Text("Borrar tabla (DEV only)"),
                          onPressed: (){
                            presenter.delete();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}