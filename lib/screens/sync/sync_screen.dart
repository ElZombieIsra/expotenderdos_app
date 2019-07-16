import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/style.dart';
import 'package:flutter/material.dart';

import 'package:expotenderos_app/components/master_scaffold.dart';
import 'sync_presenter.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  @override 
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext ctx) {
        return MasterScaffold(
          TabBarView(
            controller: _controller,
            children: [
              ShopkeepersView(false),
              ShopkeepersView(true),
            ],
          ),
          title: "Tenderos",
          bottom: TabBar(
            indicatorColor: secondaryColor,
            controller: _controller,
            tabs: [
              Tab(text: "No sincronizados",),
              Tab(text: "Sincronizados",),
            ],
          ),
          floatingActionButton: FloatingButton(),
        );
      },
    );
  }
}

class FloatingButton extends StatefulWidget {
  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {

  SyncPresenter presenter = SyncPresenter();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: secondaryColor,
      child: Icon(Icons.sync),
      onPressed: (){
        presenter.syncShopkeepers()
        .then((synced) {
          if (synced) {
            setState(() {
              globals.showSnackbar(context, "Tenderos sincronizados");
            });
          }
          else{
            globals.showSnackbar(context, "Ocurrió un error al sincronizar");
          }
        });
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
                subtitle: Text("${keeper.shop.address}"),
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