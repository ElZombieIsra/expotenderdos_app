import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/style.dart';
import 'package:flutter/material.dart';

import 'package:expotenderos_app/components/master_scaffold.dart';
import 'package:flutter/scheduler.dart';
import 'sync_presenter.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {

  @override
  void initState() {
    globals.msg = globals.Msg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext ctx) {
        return MasterScaffold(
          ShopkeepersView(false),
          title: "Tenderos",
          floatingActionButton: FloatingButtons(
            callback: () => setState(() => ''),
          ),
        );
      },
    );
  }
}

class ShopkeepersView extends StatefulWidget {

  final bool synced;

  ShopkeepersView(this.synced);

  @override
  _ShopkeepersViewState createState() => _ShopkeepersViewState();
}

class _ShopkeepersViewState extends State<ShopkeepersView> {

  @override
  Widget build(BuildContext context) {

    // Executes the function when the screen finishes loading
    SchedulerBinding.instance.endOfFrame.then((_) {
      if (globals.msg != null && globals.msg.send) {
        globals.msg.print(context);
      }
    });
    return FutureBuilder(
      future: SyncPresenter().getKeepers(widget.synced),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext ctx, i) {
              Shopkeeper keeper = snapshot.data[i];
              return ListTile(
                leading: Text("${keeper.id}"),
                title: Text("${keeper.shop.name}"),
                subtitle: Text("${keeper.email}"),
                trailing: Text("${keeper.code}"),
              );
            },
          );
        }
        return Center(
          child: Text("No hay tenderos ${widget.synced ? "" : "no "}sincronizados"),
        );
      },
    );
  }
}

class FloatingButtons extends StatefulWidget {

  final Function callback;

  FloatingButtons({this.callback});

  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> with SingleTickerProviderStateMixin {

  SyncPresenter presenter = SyncPresenter();
  bool pressed = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FloatingActionButton(
          mini: true,
          backgroundColor: secondaryColor,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, "/registerShopkeeper");
          },
        ),
        Container(
          height: 10.0,
          width: 0.0,
        ),
        FutureBuilder(
          future: presenter.getKeepers(false),
          builder: (BuildContext ctx, snap) {
            return FloatingActionButton(
              heroTag: "0",
              backgroundColor: secondaryColor,
              child: Icon(
                snap.hasData && snap.data.length > 0 
                ? Icons.sync 
                : Icons.sync_disabled
              ),
              onPressed: () {
                if (snap.hasData && snap.data.length > 0) {
                  if (pressed){
                    globals.showSnackbar(context, "Ya se están sincronizando");
                    return;
                  } 
                  pressed = true;
                  globals.showSnackbar(context, "Sincronizando");
                  presenter.syncShopkeepers().then((synced) {
                    if (synced) {
                      setState(() {
                        globals.showSnackbar(context, "Tenderos sincronizados");
                        pressed = false;
                        widget.callback();
                      });
                    }
                  });
                }
                else {
                  globals.showSnackbar(context, "No hay tenderos para sincronizar");
                }
              },
            );
          },
        ),
      ],
    );
  }
}