import 'package:expotenderos_app/services/database.dart';

class Shopkeeper{

  final String tableName = "Shopkeepers";
  int id;
  final List types = ["Dueño", "Trabajador"];
  int type;
  String name;
  String email;
  String phone;
  final List genders = ["Hombre", "Mujer"];
  int gender;
  int age;

  Shop shop;

  String code;
  bool privacy = false;

  Shopkeeper() {
    this.shop = Shop();
  }

  Shopkeeper.map(dynamic obj) {
    this.id = obj["id"];
    this.type = obj["type"];
    this.name = obj["name"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    if (obj["gender"] != null) {
      try {
        this.gender = int.parse(obj["gender"]);
      } catch (e) {
        print(e);
      }
    }
    if (obj["age"] != null) {
      try {
        this.age = obj["age"];
      } catch (e) {
        print(e);
      }   
    }

    this.shop = Shop.map(obj);

    this.code = obj["code"];
    this.privacy = obj["privacy"] == "1" ? true : false;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    if(id != null) map["id"] = this.id;
    map["type"] = this.type;
    map["name"] = this.name;
    map["email"] = this.email;
    map["phone"] = this.phone;
    if (gender != null) map["gender"] = this.gender;
    if (age != null) map["age"] = this.age;

    map["shop_name"] = this.shop.name;
    map["shop_address"] = this.shop.address;
    map["shop_picture"] = this.shop.picture;
    map["shop_location"] = this.shop.location;
    // map["shop"] = shop.toMap();

    map["code"] = this.code;
    map["privacy"] = this.privacy ? 1 : 0;

    return map;
  }

  Future<int> save() async {
    
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    if (this.id != null) {
      try {
        int id = await client.update(tableName, this.toMap(),
          where: "id = ?",
          whereArgs: [this.id],
        );
        return id;
      } catch (e) {
        print(e);
        return null;
      }
    }
    else {
      try {
        print(this.toMap());
        int id = await client.insert(tableName, this.toMap());
        return id;
      } catch (e) {
        print(e);
        return null;
      }
    }

  }

}

class Shop {
  
  String name;
  String address;
  String picture;
  String location;

  Shop();

  Shop.map(dynamic obj) {
    this.name = obj["shop_name"];
    this.address = obj["shop_address"];
    this.picture = obj["shop_picture"];
    this.location = obj["shop_location"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["name"] = name;
    map["address"] = address;
    map["picture"] = picture;
    map["location"] = location;

    return map;
  }
}