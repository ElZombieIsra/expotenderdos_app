import 'package:expotenderos_app/components/badge/main_badge.dart';
import 'package:expotenderos_app/screens/sync/sync_presenter.dart';


import 'package:flutter/material.dart';

import 'package:expotenderos_app/globals.dart' as globals;

import 'package:expotenderos_app/services/auth.dart';
import 'package:package_info/package_info.dart';

class MasterScaffold extends StatefulWidget { 

  final Widget body;
  final String title;
  final Widget bottom;
  final Widget floatingActionButton;

  MasterScaffold(this.body, {
    this.title,
    this.bottom,
    this.floatingActionButton,
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
        actions: <Widget>[
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (BuildContext ctx, snap) {
              if (snap.hasData) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text("v${snap.data.version}",
                      style: TextStyle(
                        fontSize: 20.0,
                        
                      ),
                    ),
                  )
                );
              }
              return Container();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    child: Image.asset("assets/tendero.PNG"),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      globals.user.username,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListTile(
                    title: Text("Tenderos sincronizados"),
                    trailing: FutureBuilder(
                      future: SyncPresenter().getKeepers(true),
                      builder: (BuildContext ctx, snap) {
                        if (snap.hasData) return MainBadge("${snap.data.length}");

                        return MainBadge("0");                        

                      },
                    ),
                  ),
                  // ListTile(
                  //   title: Text("Registrar tendero"),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.of(context).pushNamed("/registerShopkeeper");
                  //   } 
                  // ),
                  // ListTile(
                  //   title: Text("Sincronizar tenderos"),
                  //   onTap: () => Navigator.of(context).pushNamedAndRemoveUntil("/syncScreen", (_) => false),
                  // ),
                  ListTile(
                    title: Text("Cerrar Sesión"),
                    onTap: () async {
                      bool loggedOff = await Auth().logOffUser();
                      if(loggedOff){
                        Navigator.of(context).pushNamedAndRemoveUntil("/loginScreen", (_) => false);
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
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      "assets/wtc.PNG",
                      scale: 4.0,
                    ),
                    Image.asset(
                      "assets/pepsi.PNG",
                      scale: 3.0,
                    ),
                  ],
                ),
                Container(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Image.asset(
                        "assets/facebook.PNG",
                        scale: 5.0,
                      ),
                      onPressed: () {},
                    ),
                    FlatButton(
                      child: Image.asset(
                        "assets/instagram.PNG",
                        scale: 5.0,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Container(
                  height: 20.0,
                )
              ],
            )
          ],
        )
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}