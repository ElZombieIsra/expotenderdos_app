import 'package:flutter/material.dart';

import 'package:expotenderos_app/globals.dart' as globals;

import 'package:expotenderos_app/services/auth.dart';

class MasterScaffold extends StatefulWidget {

  final Widget body;
  final String title;
  final Widget bottom;

  MasterScaffold(this.body, {
    this.title,
    this.bottom
  });

  @override
  _MasterScaffoldState createState() => _MasterScaffoldState();
}

class _MasterScaffoldState extends State<MasterScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? globals.title),
        bottom: widget.bottom,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "${widget.title ?? globals.title}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
            ),
            ListTile(
              title: Text("Inicio"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, "/welcomeScreen", (_) => false);
              },
            ),
            ListTile(
              title: Text("Registrar tendero"),
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil("/registerShopkeeper", (_) => false),
            ),
            ListTile(
              title: Text("Sincronizar tenderos"),
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil("/syncScreen", (_) => false),
            ),
            ListTile(
              title: Text("Cerrar Sesión"),
              onTap: () async {
                bool loggedOff = await Auth().logOffUser();
                if(loggedOff){
                  Navigator.of(context).pushNamedAndRemoveUntil("/home", (_) => false);
                }
                else{
                  print("Error al cerrar sesión");
                  Navigator.pop(context);
                  Builder(
                    builder: (BuildContext ctx){
                      globals.showSnackbar(ctx, "Ocurrió un error al tratar de cerrar sesión");
                      return;
                  });
                }
              },
            )
          ],
        ),
      ),
      body: widget.body,
    );
  }
}