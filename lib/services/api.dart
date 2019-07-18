import 'dart:async';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/network.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class ExpoTenderosApi {
  NetworkService _netUtil = NetworkService();
  // static const BASE_URL = "https://expotendero.mx/";
  static const BASE_URL = "https://my-json-server.typicode.com/ElZombieIsra/expotenderdos_app";
  static const LOGIN_URL = BASE_URL + "/users";
  static const KEEPER_URL = BASE_URL + "/shopkeepers";
  // static const _API_KEY = "somerandomkey";

  Future<dynamic> login(String username, String password) async {

    String url = "$LOGIN_URL?email=$username&password=$password";

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
      if (res) {
        return true; 
      }
      return false;
  }
}