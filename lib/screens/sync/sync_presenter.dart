import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/database.dart';
import 'package:expotenderos_app/services/api.dart';

class SyncPresenter {

  SyncPresenter();

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
    ExpoTenderosApi api = ExpoTenderosApi();
    try {
      List<Shopkeeper> shopkeepers = await this.getKeepers(false);
      bool tmp = false;
      for (var i = 0; i < shopkeepers.length; i++) {
        Shopkeeper keeper = shopkeepers[i];
        bool synced = await api.syncShopkeeper(keeper);
        // bool synced = true;
        if (synced) {
          keeper.synced = true;
          int id = await keeper.save();
          if (id != null) tmp = true;
        }
      }
      return tmp;
    } catch (e) {
      print("Api error");
      return false;
    }
  }
}