import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/style.dart';
import 'package:flutter/material.dart';

import 'package:expotenderos_app/components/master_scaffold.dart';
import 'package:flutter/scheduler.dart';
import 'sync_presenter.dart';
import 'package:expotenderos_app/globals.dart' as globals;

Future future;

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
            callback: (){
              setState(() {
                SyncPresenter().getKeepers(false);
              });
            },
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
        SchedulerBinding.instance.endOfFrame.then((_) {
          setState(() {
            future = SyncPresenter().getKeepers(false);
          });
        });
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

  FloatingButtons({
    this.callback,
  });

  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;
  SyncPresenter presenter = SyncPresenter();
  bool sentAlert = false;

  @override
  void initState() {

    future = presenter.getKeepers(false);

    super.initState();

    controller = AnimationController(
      duration: const Duration(
        seconds: 60
      ),
      vsync: this,
    );

    animation = Tween<double>(
      begin: 60,
      end: 0,
    ).animate(controller);
    controller.repeat();

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
          future: future,
          builder: (BuildContext ctx, snap) {

            future = presenter.getKeepers(false);

            Widget child;

            if (snap.connectionState != ConnectionState.done) {
              // print('active');
              child = RotationTransition(
                child: Icon(Icons.sync),
                turns: animation,
              );
            }
            else {
              if (snap.hasData && (snap.data == true || snap.data == false)) {

                // Updates the future when state of the widget is finished
                SchedulerBinding.instance.endOfFrame.then((_) {
                  setState(() {
                    future = presenter.getKeepers(false);       
                  });
                  if (snap.data) widget.callback();

                  // Show the alert when the state is finished
                  SchedulerBinding.instance.endOfFrame.then((_) {
                    globals.showSnackbar(context, snap.data ? "Tenderos sincronizados" : "Ocurrió un error al sincronizar");                    
                  });
                });
              }
              else {
                child = Icon(
                  snap.hasData && snap.data.length > 0 
                  ? Icons.sync 
                  : Icons.sync_disabled
                );
              }
            }

            return FloatingActionButton(
              heroTag: "0",
              backgroundColor: secondaryColor,
              child: child,
              onPressed: () {
                if (snap.connectionState != ConnectionState.done) {
                  if (!sentAlert){
                    globals.showSnackbar(context, "Ya se están sincronizando");                  
                    sentAlert = true;
                  } 
                  return;
                }
                sentAlert = false;
                
                if (snap.hasData && snap.data.length > 0) {
                  setState(() {
                    future = presenter.syncShopkeepers();
                  });
                }
                else {
                  setState(() {
                    globals.showSnackbar(context, "No hay tenderos para sincronizar");
                  });
                }
              },
            );
          },
        ),
      ],
    );
  }
}