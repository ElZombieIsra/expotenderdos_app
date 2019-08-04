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
}