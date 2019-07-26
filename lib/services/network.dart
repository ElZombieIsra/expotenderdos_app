import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  // next three lines makes this class a Singleton
  static NetworkService _instance = NetworkService.internal();
  NetworkService.internal();
  factory NetworkService() => _instance;

  final JsonDecoder _decoder = JsonDecoder();

  Future<dynamic> get(String url) async {
    http.Response response = await http.get(url);
    final String res = response.body;
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception("Error while fetching data");
    }
    return _decoder.convert(res);
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    print(jsonEncode(body));
    http.Response response = await http.post(
      Uri.encodeFull(url), 
      body: jsonEncode(body), 
      headers: headers, 
      encoding: encoding
    );
    final String res = response.body;
    final int statusCode = response.statusCode;
    print(res);
    if (statusCode < 200 || statusCode > 400 || statusCode == 301) {
      throw Exception("Error while fetching data");
    }
    return _decoder.convert(res);
  }
}