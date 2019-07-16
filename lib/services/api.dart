import 'dart:async';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/network.dart';
import 'package:expotenderos_app/models/User.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class ExpoTenderosApi {
  NetworkService _netUtil = NetworkService();
  static const BASE_URL = "https://expotendero.mx/";
  static const LOGIN_URL = BASE_URL + "/login";
  static const KEEPER_URL = BASE_URL + "/shopkeepers";
  static const _API_KEY = "somerandomkey";

  Future<User> login(String username, String password) async {
    _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw Exception(res["error_msg"]);
      return User.map(res["user"]);
    }).catchError((err) {
      print(err);
      return null;
    });
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