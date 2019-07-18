import 'package:expotenderos_app/services/database.dart';

class User {
  int _id;
  String username;
  String _password;
  bool _loggedIn;
  String token;

  User();

  User.map(dynamic obj) {
    this._id = obj["id"];
    this.username = obj["username"];
    this._password = obj["password"];
    this._loggedIn = obj["loggedIn"] is int ? (obj["loggedIn"] == 0 ? false : true) : obj["loggedIn"];
    this.token = obj["token"];
  }

  int get id => _id;
  set id(int id) => this._id = id;

  String get password => _password;
  set password(String password) => this._password = password;

  bool get loggedIn => _loggedIn;
  set loggedIn(bool logged) => this._loggedIn = logged;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(_id != null){
      map["id"] = _id;
    }
    map["username"] = this.username;
    map["password"] = _password;
    if (_loggedIn != null) {
      map["loggedIn"] = _loggedIn ? 1 : 0;
    }
    if (this.token != null) {
      map["token"] = this.token;
    }

    return map;
  }

  // Gets user from the database
  Future<User> getRecord() async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;
    var res = await client.query("User", 
      where: "username = ? AND password = ? ",
      whereArgs: [this.username, this._password],
    );

    if(res.length != 0){
      return User.map(res.first);
    }

    return null;
  }

  // Updates the user in the database
  Future<bool> save() async {
    
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    var res = await client.update("User", this.toMap(), 
      where: "id = ?",
      whereArgs: [this._id],
    );

    if(res != null) return true;

    return false;
  }
}