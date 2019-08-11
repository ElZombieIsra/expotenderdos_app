import 'package:flutter/material.dart';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/validations.dart';
import 'package:expotenderos_app/style.dart';
import 'package:expotenderos_app/globals.dart' as globals;
import 'package:expotenderos_app/screens/register/register_presenter.dart';

import 'package:expotenderos_app/components/buttons/main_button.dart';
import 'package:expotenderos_app/components/combo_tile.dart';

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
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  bool autovalidate = false, _referred = false;
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
                controller: _controllers[7],
                decoration: fieldDecoration(
                  label: true,
                  hint: "Código postal",
                ),
                keyboardType: TextInputType.number,
                onSaved: (val) => shopkeeper.shop.postalCode = int.parse(val),
                validator: validations.validatePostalCode,
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
                    future: presenter.getCurrentCombo(shopkeeper.combo),
                    builder: (BuildContext ctx, snap) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Conferencias:'),
                              snap.hasData ? Icon(Icons.edit, size: 15.0,) : Icon(Icons.add),
                            ],
                          ),
                          snap.hasData ? ComboTile(snap.data) : Container(),
                        ],
                      );
                    },
                  );

                },
              ),
              onTap: () {
                _settingModalBottomSheet(
                  context, 
                  shopkeeper, 
                  presenter.getCombos(),
                  (combo) => setState(() => shopkeeper.combo = combo)
                );
              },
            ),
            Builder(
              builder: (BuildContext ctx) {
                if (!_referred) {
                  return ListTile(
                    title: Column(
                      children: <Widget>[
                        Text("¿Quieres asistir con un invitado?"),
                        FlatButton(
                          child: Text("Regístralo ahora"),
                          onPressed: () => setState(() => _referred = true),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: TextFormField(
                        controller: _controllers[8],
                        decoration: fieldDecoration(
                          label: true,
                          hint: "Nombre completo del acompañante",
                        ),
                        onSaved: (val) => shopkeeper.referredName = val,
                        validator: validations.validateName,
                      ),
                    ),
                    // ListTile(
                    //   title: TextFormField(
                    //     textCapitalization: TextCapitalization.characters,
                    //     controller: _controllers[9],
                    //     decoration: fieldDecoration(
                    //       label: true,
                    //       hint: "Código de gafete (QR)",
                    //       suffixIcon: IconButton(
                    //         icon: Icon(Icons.camera_alt),
                    //         onPressed: (){
                    //           presenter.readQrCode().then((val) => _controllers[9].text = val);
                    //         },
                    //       ),
                    //     ),
                    //     keyboardType: TextInputType.text,
                    //     onSaved: (val) => shopkeeper.referredCode = val,
                    //     validator: validations.validateCode,
                    //   ),
                    // ),
                  ],
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
                                Text("Aviso de privacidad para la protección de datos personales.\n\nEn términos de lo previsto en la Ley Federal de Protección de Datos Personales en Posesión de los Particulares, la aportación que hagas de tus datos Personales a Gsfera S.A. de C.V. (Gsfera) la aceptación de estos Términos y Condiciones:\n\n1.- El presente Aviso tiene por objeto la protección de tus datos personales (tu nombre, tu número telefónico, el nombre de tu negocio (tienda), mediante su tratamiento legítimo, controlado e informado, a efecto de garantizar su privacidad, así como tu derecho a la autodeterminación informativa.\n\n2.- Conforme al artículo 3, fracción V, de la Ley, se entiende por Datos Personales: Cualquier información concerniente a una persona física identificada o identificable.\n\n3.- Gsfera, de conformidad a lo dispuesto por la fracción I del artículo 16 de la Ley, será el Responsable de tu información personal (Datos Personales). Gsfera hará uso de los datos únicamente para dar acceso a la “Expo Tendero” a realizarse el 06 de noviembre de 2019, así como para mantenerte al tanto de la información concerniente a Gsfera.\n\n4.- Al participar en el proceso de ingreso a la “Expo Tendero”, autorizas a Gsfera a utilizar y tratar de forma automatizada tus datos personales e información suministrados, los cuales formarán parte de nuestra base de datos con la finalidad de usarlos en forma enunciativa para identificarte, ubicarte, comunicarte, contactarte, enviarte información, actualizar nuestra base de datos y obtener estadísticas.\n\n6.- La temporalidad del manejo de tus Datos Personales será indefinida a partir de la fecha en que nos los proporciones.\n\n7.- Gsfera, como responsable del tratamiento de tus datos personales, está obligada a cumplir con los principios de licitud, consentimiento, información, calidad, finalidad, lealtad, proporcionalidad y responsabilidad tutelados en la Ley; por tal motivo con fundamento en los artículos 13 y 14 de la Ley, Gsfera se compromete a tratar tu información con normas de confidencialidad y seguridad administrativa.\n\n8.- En términos de lo establecido por el artículo 22 de la Ley, tienes derecho en cualquier momento a ejercer tus derechos de acceso, rectificación, cancelación y oposición al tratamiento de tus datos personales.\n\nEn caso de que requieras algún cambio deberás enviar un correo a ________________. En cumplimiento al artículo 29 de la Ley, dicha solicitud deberá contener los siguientes datos: a) Tu nombre y domicilio u otro medio para comunicarte la respuesta a tu solicitud; b) Los documentos que acrediten tu identidad o, en su caso, la representación legal de la persona que realiza la solicitud a tu nombre; c) La descripción clara y precisa de los datos personales respecto de los que buscas ejercer alguno de los derechos mencionados en el párrafo anterior, y d) Cualquier otro elemento o documento que facilite la localización de tus datos personales. En caso de solicitar la rectificación de datos personales, adicionalmente deberás indicar las modificaciones a realizarse y aportar la documentación que sustente tu petición. La respuesta a tu solicitud se te comunicará en un plazo de veinte días hábiles, contados desde la fecha en que se recibió, pudiendo ampliarse a veinte días más en los casos que así lo establezcan la Ley; a efecto de que de resultar procedente, se lleven a cabo las medidas adoptadas para cumplir con tu solicitud, mismas que se llevarán a cabo dentro de los quince días hábiles siguientes a la fecha en que se comunique la respuesta.\n\n9.- Te sugerimos conocer y analizar el contenido de la Ley Federal de Protección de Datos Personales en Posesión de los Particulares pues pueden generarse cambios normativos a los que estamos sujetos.", 
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
                        controllers: _controllers,
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

  /// Combo selection panel
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
                    child: ComboTile(snap.data[i],

                      /// If its already selected, disables the tile
                      enabled: keeper.combo != snap.data[i].id,
                      onTap: () {
                        setState(() {
                          keeper.combo = snap.data[i].id;
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