import 'package:expotenderos_app/services/api.dart';
import 'package:expotenderos_app/services/database.dart';

import 'package:expotenderos_app/models/User.dart';
import 'package:expotenderos_app/globals.dart' as globals;

class Auth {
  User user;
  DatabaseHelper db = DatabaseHelper();
  ExpoTenderosApi _api = ExpoTenderosApi();

  /// Verifies if the [user] is in the database and 
  /// returns the `loggedIn` status of the [user] if exists.
  Future<bool> isUserLoggedIn(User user) async {
    User _user = await user.getRecord();
    if(_user != null){
      return user.loggedIn;
    }
    
    return false;
  }

  /// Verifies if theres an user in the database with the `loggedIn` status
  /// set to true.
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

  /// Logs the user in
  /// 
  /// If the [email] and [password] exists either locally or remotely in the API
  /// logs the user in.
  /// 
  /// If the user exists remotely but not locally, creates a local record of the user
  /// so the user doesn't needs to use connection to log in again.
  Future<User> logInUser(String username, String password) async {

    // Verifies there's a local record of the user
    User localUser = User();
    localUser.username = username;
    localUser.password = password;
    localUser = await localUser.getRecord();

    // If the user is saved locally, logs him in without reaching the API
    if (localUser != null) {
      localUser.loggedIn = true;
      await localUser.save();
      return localUser;
    }

    // Reachs the API for the user
    var response = await _api.login(username, password);
    User user = User.map(response);

    // Logs him in if exists in the API and creates a local record of the user
    if (user != null) {
      user.id = await db.saveUser(user);
      user.loggedIn = true;
      await user.save();
      return user;
    }

    return null;
  }

  /// Changes the user `loggedIn` status in the database and the global model
  Future<bool> logOffUser() async {
    if(globals.user == null){
      return false;
    }
    try {
      globals.user.loggedIn = false;
      await globals.user.save();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}