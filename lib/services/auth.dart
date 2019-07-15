import 'package:expotenderos_app/services/database.dart';

import 'package:expotenderos_app/models/User.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class Auth {
  User user;
  DatabaseHelper db = DatabaseHelper();

  Future<bool> isUserLoggedIn(user) async {
    var client = await db.db;
    var _user = await client.query("User", 
      where: 'id = ?',
      whereArgs: [user.id],
    );
    if(_user.length != 0){
      user = User.map(_user.first);
      return user.loggedIn;
    }
    
    return false;
  }

  Future<User> isSomeoneLoggedIn() async {
    var client = await db.db;
    var res = await client.query("User",
      where: 'loggedIn = ?',
      whereArgs: [1]
    );

    if (res.length != 0) {
      User user = User.map(res.first);
      return user;
    }

    return null;
  }

  Future<bool> logOffUser() async {
    if(globals.user == null){
      return false;
    }
    try {

      var dbClient = await db.db;
      globals.user.loggedIn = false;
      await dbClient.update("User", globals.user.toMap());

    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}