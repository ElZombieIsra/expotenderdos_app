import 'package:flutter/material.dart';

import 'package:expotenderos_app/components/master_scaffold.dart';
import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/validations.dart';
import 'package:expotenderos_app/style.dart';
import 'package:expotenderos_app/globals.dart' as globals;
import 'package:expotenderos_app/screens/register/register_presenter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  bool autovalidate = false;
  Validations validations = Validations();
  Shopkeeper shopkeeper = Shopkeeper();
  RegisterPresenter presenter = RegisterPresenter();
  var img;

  @override
  Widget build(BuildContext context) {
    return MasterScaffold(
      Form(
        key: formKey,
        autovalidate: autovalidate,
        child: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
          children: <Widget>[
            ListTile(
              title: Text("El tendero es:"),
            ),
            ListTile(
              leading: Radio(
                value: 0,
                groupValue: shopkeeper.type,
                onChanged: (val){
                  setState(() {
                    shopkeeper.type = val; 
                  });
                },
              ),
              title: Text(shopkeeper.types[0]),
            ),
            ListTile(
              leading: Radio(
                value: 1,
                groupValue: shopkeeper.type,
                onChanged: (val){
                  setState(() {
                  shopkeeper.type = val; 
                  });
                },
              ),
              title: Text(shopkeeper.types[1]),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[0],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Nombre",
                ),
                onSaved: (val) => shopkeeper.name = val,
                validator: validations.validateName,
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[1],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Correo electrónico",
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => shopkeeper.email = val,
                validator: validations.validateEmail,
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[2],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Número de teléfono",
                ),
                keyboardType: TextInputType.phone,
                onSaved: (val) => shopkeeper.phone = val,
                validator: validations.validatePhoneNumber,
              ),
            ),
            ListTile(
              title: Text("Género"),
              subtitle: Text("(Opcional)"),
            ),
            ListTile(
              leading: Radio(
                value: 0,
                groupValue: shopkeeper.gender,
                onChanged: (val){
                  setState(() {
                    shopkeeper.gender = val;
                  });
                },
              ),
              title: Text(shopkeeper.genders[0]),
            ),
            ListTile(
              leading: Radio(
                value: 1,
                groupValue: shopkeeper.gender,
                onChanged: (val){
                  setState(() {
                    shopkeeper.gender = val;
                  });
                },
              ),
              title: Text(shopkeeper.genders[1]),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[3],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Edad (opcional)"
                ),
                keyboardType: TextInputType.number,
                onSaved: (val) => val.isNotEmpty ? shopkeeper.age = int.parse(val) : 0,
                validator: validations.validateAge,
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Datos de la tienda"),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[4],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Nombre",
                ),
                onSaved: (val) => shopkeeper.shop.name = val,
                validator: validations.validateShopName,
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[5],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Dirección"
                ),
                onSaved: (val) => shopkeeper.shop.address = val,
                validator: validations.validateShopAddress,
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[6],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Código",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: (){
                      presenter.readQrCode().then((val) => _controllers[6].text = val);
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (val) => shopkeeper.code = val,
                validator: validations.validateCode,
              ),
            ),
            ListTile(
              title: Builder(
                builder: (BuildContext ctx) {
                  if (img != null) {
                    return SizedBox(
                      height: 300.0,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.file(img),
                      ),
                    );
                  }
                  return RaisedButton(
                    child: Text("Tomar foto"),
                    onPressed: () {
                      presenter.getPicture()
                      .then((pic) => setState(() {
                        if (pic != null) {
                          shopkeeper.shop.picture = pic.path;
                          img = pic;
                        }
                      }));
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: Checkbox(
                value: shopkeeper.privacy,
                onChanged: (val) => setState(() => shopkeeper.privacy = val),
              ),
              title: Text("He leído y acepto el acuerdo de privacidad"),
            ),
            ListTile(
              title: Builder(
                builder: (BuildContext ctx) {
                  return RaisedButton(
                    child: Text("Guardar"),
                    onPressed: () {
                      presenter.submit(
                        form: formKey,
                        shopkeeper: shopkeeper,
                      )
                      .then((validate){
                        if (validate != null) {
                          autovalidate = true;
                          globals.showSnackbar(ctx, validate);
                        }
                        else {
                          presenter.sendForm(_controllers, shopkeeper)
                          .then((val){
                            if (val != null) {
                              setState(() {
                                globals.showSnackbar(ctx, "Tendero guardado");
                                shopkeeper = Shopkeeper();
                                 _controllers = [
                                  TextEditingController(),
                                  TextEditingController(),
                                  TextEditingController(),
                                  TextEditingController(),
                                  TextEditingController(),
                                  TextEditingController(),
                                  TextEditingController(),
                                ];
                                autovalidate = false;
                                formKey.currentState?.reset();
                                img = null;
                              });
                            }
                            else {
                              globals.showSnackbar(ctx, "No se pudo guardar");
                            }
                          });
                        }
                      });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      title: "Registrar tendero"
    );
  }
}