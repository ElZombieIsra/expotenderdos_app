import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:expotenderos_app/services/network.dart';
import 'package:expotenderos_app/globals.dart' as globals;

import 'package:flutter/foundation.dart' as Foundation;

class ExpoTenderosApi {
  NetworkService _netUtil = NetworkService();
  static const BASE_URL = Foundation.kReleaseMode ? "https://expotendero.org/api" : "http://192.168.100.237/tenderos/public/api";
  // static const BASE_URL = "https://expotendero.org/api";
  static const LOGIN_URL = BASE_URL + "/login";
  static const KEEPER_URL = BASE_URL + "/shopkeepers";
  static const ACTIVITY_URL = BASE_URL + "/activity";

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

  Future<dynamic> syncShopkeeper(Shopkeeper keeper) async {
      var res = await _netUtil.post(KEEPER_URL,
        body: {
          "api_token": globals.user.token,
          "shopkeepers": [keeper.toMap()],
        },
        headers: {
          'Content-Type': 'application/json',
        }
      );
      if (res["shopkeepers"][0] != null) {
        return true; 
      }
      return false;
  }

  Future<dynamic> syncShopkeepers(List<Shopkeeper> keepers) async {
    // await Future.delayed(Duration(seconds: 20));
    List shopkeepers = [];
    for (var keeper in keepers) {
      print(keeper);
      try {
        File imgFile = File(keeper.shop.picture);
        List<int> bytes = await imgFile.readAsBytes();
        keeper.shop.picture = base64Encode(bytes);
      } catch (e) {
        print(e);
      } 
      shopkeepers.add(keeper.toMap());
    }
    var res = await _netUtil.post(KEEPER_URL,
      body: {
        "api_token": globals.user.token,
        "shopkeepers": shopkeepers,
      }
    );
    
    if (res["shopkeepers"] == null) {
      throw Exception("No se pudieron sincronizar los tenderos");
    }
    return res["shopkeepers"];
  } 

  Future syncCombos() async {

    var res = await _netUtil.get(ACTIVITY_URL);

    if (res.length == 0) {
      throw Exception("Error while reaching the API");
    }

    return res;

  }
}