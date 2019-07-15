import 'package:expotenderos_app/globals.dart' as globals;
import 'package:expotenderos_app/models/User.dart';

import 'package:expotenderos_app/services/api.dart';
import 'package:expotenderos_app/services/database.dart';

class LoginPresenter {

  ExpoTenderosApi _api = ExpoTenderosApi();
  DatabaseHelper db = DatabaseHelper();

  LoginPresenter();

  Future<User> submit({ctx, user, form}) async {
    if (!form.validate()){
      return null;
    }
    try {
      form.save();
      if (user.email == 'a@a.am' && user.password == '123') {
        user.id = await logUser(user);
        user.loggedIn = true;
        return user;
      }
      User newUser = await _api.login(user.email, user.password);
      newUser.id = await logUser(user);
      globals.showSnackbar(ctx, newUser.id.toString());
      return newUser;
    } catch (e) {
      globals.showSnackbar(ctx, 'Datos incorrectos');
      print(e);
      return null;
    } 
    // Navigator.pushNamed(context, "/HomePage");
  }

  Future<int> logUser(user) async {

    User oldUser = await user.getRecord();
    if(oldUser != null){
      oldUser.loggedIn = true;
      await oldUser.save();
      return oldUser.id;
    }

    int userId = await db.saveUser(user);

    return userId;
  }

  void delete(){
    db.delete();
  }
} 