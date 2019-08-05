import 'dart:math';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/database.dart';
import 'package:expotenderos_app/services/api.dart';

class SyncPresenter {

  SyncPresenter();

  ExpoTenderosApi _api = ExpoTenderosApi();

  /// Get keepers from database
  /// 
  /// When [synced] is true gets all syncronized shopkeepers.
  /// When [synced] is false gets all not syncronized shopkeepers.
  Future<List<Shopkeeper>> getKeepers(synced) async {

    DatabaseHelper database = DatabaseHelper();
    var client = await database.db;

    var res = await client.query(Shopkeeper().tableName,
      where: "synced = ?",
      whereArgs: [synced ? "1" : "0"],
    );
    
    if (res.length > 0) {
      List<Shopkeeper> keepers = [];
      for (var keeper in res) {
        keepers.add(Shopkeeper.map(keeper));
      }
      return keepers;
    }

    return null;
    
  }

  Future<bool> syncShopkeepers() async {
    // await Future.delayed(const Duration(seconds: 10));
    try {
      List<Shopkeeper> shopkeepers = await this.getKeepers(false);
      var res = await _api.syncShopkeepers(shopkeepers);
      // print(res);
      for (var i = 0; i < res.length; i++) {
        Shopkeeper keeper = await Shopkeeper().getKeeper(res[i]["id"]);
        keeper.idServer = res[i]["id_server"];
        keeper.synced = true;
        await keeper.save();
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> syncShopkeeper(Shopkeeper keeper) async {
    try {
      bool synced = await _api.syncShopkeeper(keeper);
      // bool synced = true;
      if (!synced) return false;

      keeper.synced = true;
      await keeper.save();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createDummy() async {

    for (var i = 0; i < 52; i++) {
      Shopkeeper keeper = Shopkeeper.map({
        "type": 1,
        "name": this._randomString(),
        "email": "${this._randomString()}@as.as",
        "phone": "5555555555",
        "shop_name": this._randomString(),
        "shop_address": this._randomString(),
        "shop_postal_code": 15600,
        "shop_picture": this._randomString(),
        "shop_location": this._randomString(),
        "combo": 1,
        "code": this._randomString().toUpperCase(),
        "privacy": "1",
      });
      await keeper.save();
    } 

    return true;

  }

  String _randomString() {
    var rand = Random();
    var codeUnits = List.generate(
        6, 
        (index){
          return rand.nextInt(33)+89;
        }
    );
    
    return String.fromCharCodes(codeUnits);
  }
}