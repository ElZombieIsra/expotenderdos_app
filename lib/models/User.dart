import 'package:expotenderos_app/services/database.dart';

class User {
  int id;
  String username;
  String password;
  bool loggedIn;
  String token;

  User();

  User.map(dynamic obj) {
    this.id = obj["id"];
    this.username = obj["username"];
    this.password = obj["password"];
    this.loggedIn = obj["loggedIn"] is int ? (obj["loggedIn"] == 0 ? false : true) : obj["loggedIn"];
    this.token = obj["token"];
  }

  Map<String, dynamic> toMap() {
    
    return {
      'id': this.id,
      'username': this.username,
      'password': this.password,
      'loggedIn': this.loggedIn ? 1 : 0,
      'token': this.token,
    };

  }

  // Gets user from the database
  Future<User> getRecord() async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;
    var res = await client.query("User", 
      where: "username = ? AND password = ? ",
      whereArgs: [this.username, this.password],
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
      whereArgs: [this.id],
    );

    if(res != null) return true;

    return false;
  }
}