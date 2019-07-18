import 'package:expotenderos_app/globals.dart' as globals;
import 'package:expotenderos_app/models/User.dart';

import 'package:expotenderos_app/services/auth.dart';
import 'package:expotenderos_app/services/database.dart';

class LoginPresenter {

  Auth auth = Auth();
  DatabaseHelper db = DatabaseHelper();

  LoginPresenter();

  Future<User> submit({ctx, user, form}) async {
    if (!form.validate()){
      return null;
    }
    try {
      form.save();
      // if (user.email == 'a@a.am' && user.password == '123') {
      //   user.id = await logUser(user);
      //   user.loggedIn = true;
      //   return user;
      // }
      
      User newUser = await auth.logInUser(user.email, user.password);
      return newUser;
    } catch (e) {
      globals.showSnackbar(ctx, 'Datos incorrectos');
      print(e);
      return null;
    } 
    // Navigator.pushNamed(context, "/HomePage");
  }

  void delete(){
    db.delete();
  }
} 