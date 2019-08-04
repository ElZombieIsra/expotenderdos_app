import 'package:expotenderos_app/services/database.dart';

class Combo {
  
  final String tableName = "Combos";

  int id;
  String name;
  String hour;

  Combo();

  Combo.map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["name"];
    this.hour = obj["hour"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "name": this.name,
      "hour": this.hour,
    };
  }

  Future<Combo> first({int id}) async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;
    var res = await client.query(tableName,
      where: "id = ?",
      whereArgs: [id ?? this.id],
    );

    if (res.length <= 0) {
      return null;
    }

    return Combo.map(res.first);

  }

  Future<List<Combo>> get() async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;
    var res = await client.query(tableName);

    if (res.length <= 0) {
      return null;
    }
    
    List<Combo> activities = [];
    for (var combo in res) {
      activities.add(Combo.map(combo));
    }
    return activities;

  }

  /// Saves the Combo in the database
  Future<bool> save() async {

    // Inserts the record in database if it doesn't exists
    if (await this.first() == null) return await this.insert();

    // Updates the record if exists
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    var res = await client.update(tableName, this.toMap(), 
      where: "id = ?",
      whereArgs: [this.id],
    );

    if(res == null) return false;

    return true;

  }

  // Inserts the Combo in the database
  Future<bool> insert() async {
    
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    var res = await client.insert(tableName, this.toMap());

    if(res == null) return false;

    return true;
    
  }
}