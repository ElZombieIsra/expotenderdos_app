import 'package:expotenderos_app/components/activity_tile.dart';
import 'package:expotenderos_app/components/buttons/main_button.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar tendero"),
      ),
      body: Form(
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
                  hint: "Nombre completo",
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
                  hint: "Número de teléfono (10 dígitos)",
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
            // ListTile(
            //   title: TextFormField(
            //     controller: _controllers[3],
            //     decoration: fieldDecoration(
            //       label: true,
            //       hint: "Edad (opcional)"
            //     ),
            //     keyboardType: TextInputType.number,
            //     onSaved: (val) => val.isNotEmpty ? shopkeeper.age = int.parse(val) : 0,
            //     validator: validations.validateAge,
            //   ),
            // ),
            Divider(),
            ListTile(
              title: Text("Datos de la tienda"),
            ),
            ListTile(
              title: TextFormField(
                controller: _controllers[4],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Nombre de la tienda",
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
                  hint: "Dirección completa"
                ),
                onSaved: (val) => shopkeeper.shop.address = val,
                validator: validations.validateShopAddress,
              ),
            ),
            ListTile(
              title: TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _controllers[6],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Código de gafete (QR)",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: (){
                      presenter.readQrCode().then((val) => _controllers[6].text = val);
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
                onSaved: (val) => shopkeeper.code = val,
                validator: validations.validateCode,
              ),
            ),
            Container(
              height: 20.0,
            ),
            ListTile(
              title: Builder(
                builder: (BuildContext ctx) {
                  return FutureBuilder(
                    future: presenter.getCurrentActivities(shopkeeper.activities),
                    builder: (BuildContext ctx, snap) {
                      List<Widget> widgets = [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Conferencias:'),
                            Icon(Icons.add),
                          ],
                        )
                      ];
                      if (snap.hasData) {
                        if (snap.data.length > 0) {
                          for (var activity in snap.data) {
                            widgets.add(ActivityTile(activity));
                          }
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widgets,
                      );
                    },
                  );
                },
              ),
              onTap: () {
                _settingModalBottomSheet(
                  context, 
                  shopkeeper, 
                  presenter.getActivities(),
                  (activities) => setState(() => shopkeeper.activities = activities)
                );
              },
            ),
            Container(
              height: 20.0,
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
                  return MainButton(
                    text: "Tomar foto",
                    fun: () {
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
                onChanged: (val) {

                  /// Opens a modal to show the privacy agreement.
                  globals.showInDialog(
                    context, 
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam a placerat elit. Quisque molestie velit tincidunt, placerat ipsum maximus, interdum orci. Nulla egestas sed nunc non eleifend. Nulla efficitur tristique orci consectetur semper. Donec eget ipsum bibendum, sagittis tortor vitae, accumsan elit. Aliquam vestibulum consectetur turpis, vel consectetur ligula posuere eu. Nam pharetra nulla vel sapien scelerisque, vitae vehicula risus dictum. Quisque feugiat neque nec quam viverra tempor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tristique cursus maximus. Donec suscipit nec metus id tempor. Aenean mollis consectetur elit, facilisis venenatis mauris consectetur ut. Suspendisse sit amet venenatis massa. Quisque tristique malesuada magna non porttitor. Donec consectetur felis vitae erat sagittis posuere. Donec in dignissim nisl, at rutrum velit.", 
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 20.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MainButton(
                              text: "Declinar",
                              fun: () {
                                setState(() => shopkeeper.privacy = false);
                                Navigator.pop(context);
                              },
                            ),
                            MainButton(
                              text: "Aceptar",
                              color: Theme.of(context).primaryColor,
                              fun: () {
                                setState(() => shopkeeper.privacy = true);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    title: "Acuerdo de privacidad",
                  );
                },
              ),
              title: Text("He leído y acepto el acuerdo de privacidad"),
            ),
            ListTile(
              title: Builder(
                builder: (BuildContext ctx) {
                  return MainButton(
                    text: "Guardar",
                    fun: () {
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
                                globals.msg.text = "Tendero guardado";
                                // globals.showSnackbar(context, "Tendero guardado");
                                Navigator.pop(context);
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
    );
  }

  void _settingModalBottomSheet(BuildContext context, Shopkeeper keeper, Future future, Function callback){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx){
        return FutureBuilder(
          future: future,
          builder: (BuildContext ct, snap) {
            if (snap.hasData) {

              return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (BuildContext c, int i) {
                  return Container(
                    child: ActivityTile(snap.data[i],

                      /// If its already selected, disables the tile
                      enabled: keeper.activities.indexOf(snap.data[i].id) == -1,
                      onTap: () {
                        if (keeper.activities.length >= 2) {
                          keeper.activities.removeAt(0);
                        }
                        setState(() {
                          keeper.activities.add(snap.data[i].id);
                          // callback(keeper.activities);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  );
                },
              );
            }

            return Text("Cargando...");
          },
        );
      }
    );
  }
}