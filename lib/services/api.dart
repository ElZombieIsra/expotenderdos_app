import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/network.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class ExpoTenderosApi {
  NetworkService _netUtil = NetworkService();
  static const BASE_URL = "http://192.168.100.237/tenderos/public/api"; // TODO: Cambiar la url
  // static const BASE_URL = "https://expotendero.org/api";
  static const LOGIN_URL = BASE_URL + "/login";
  static const KEEPER_URL = BASE_URL + "/shopkeepers";
  // static const KEEPER_URL = "http://10.0.2.2:3000/shopkeepers";

  Future<dynamic> login(String username, String password) async {

    String url = "$LOGIN_URL?username=$username&password=$password";

    var res = await _netUtil.get(url);
    // print(res);
    if (res.length == 0) {
      throw Exception("No se encontró el usuario");
    }

    // if(res[0]["error"]) throw Exception(res["error_msg"]);
    
    return res;
  }

  Future<bool> syncShopkeeper(Shopkeeper keeper) async {
      var res = await _netUtil.post(KEEPER_URL,
        body: {
          "api_token": globals.user.token,
          "shopkeeper": keeper.toMap(),
        },
        headers: {
          'Content-Type': 'application/json',
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
        "api_token": globals.user.token,
        "shopkeepers": shopkeepers,
      }
    );
    // print(res);
    if (res["shopkeepers"] == null) {
      throw Exception("No se pudieron sincronizar los tenderos");
    }
    return res["shopkeepers"];
  } 
}