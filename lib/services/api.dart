import 'dart:async';

import 'package:expotenderos_app/services/network.dart';
import 'package:expotenderos_app/models/User.dart';

class ExpoTenderosApi {
  NetworkService _netUtil = NetworkService();
  static const BASE_URL = "https://expotendero.mx/";
  static const LOGIN_URL = BASE_URL + "/login";
  static const _API_KEY = "somerandomkey";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw Exception(res["error_msg"]);
      return User.map(res["user"]);
    });
  }
}