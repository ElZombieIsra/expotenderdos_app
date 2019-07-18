import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/network.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class ExpoTenderosApi {
  NetworkService _netUtil = NetworkService();
  // static const BASE_URL = "https://expotendero.mx/";
  static const BASE_URL = "https://my-json-server.typicode.com/ElZombieIsra/expotenderdos_app";
  static const LOGIN_URL = BASE_URL + "/users";
  static const KEEPER_URL = BASE_URL + "/shopkeepers";
  // static const KEEPER_URL = "http://10.0.2.2:3000/shopkeepers";
  // static const _API_KEY = "somerandomkey";

  Future<dynamic> login(String username, String password) async {

    String url = "$LOGIN_URL?username=$username&password=$password";

    var res = await _netUtil.get(url);
    print(res);
    if (res.length == 0) {
      throw Exception("No se encontró el usuario");
    }

    // if(res[0]["error"]) throw Exception(res["error_msg"]);
    
    return res[0];
  }

  Future<bool> syncShopkeeper(Shopkeeper keeper) async {
      var res = await _netUtil.post(KEEPER_URL,
        body: {
          "userId": globals.user.id,
          "shopkeeper": keeper.toMap(),
        }
      );
      if (res["id"] != null) {
        return true; 
      }
      return false;
  }

  Future<dynamic> syncShopkeepers(List<Shopkeeper> keepers) async {
    List shopkeepers = [];
    for (var keeper in keepers) {
      File imgFile = File(keeper.shop.picture);
      List<int> bytes = await imgFile.readAsBytes();
      keeper.shop.picture = base64Encode(bytes);
      shopkeepers.add(keeper.toMap());
    }
    var res = await _netUtil.post(KEEPER_URL,
      body: {
        "user_token": globals.user.token,
        "shopkeepers": shopkeepers,
      }
    );
    print(res);
    if (res["shopkeepers"] == null) {
      throw Exception("No se pudieron sincronizar los tenderos");
    }
    return res["shopkeepers"];
  } 
}