import 'package:expotenderos_app/services/database.dart';

class Activity {
  
  final String tableName = "Activity";

  int id;
  int capacitySite;
  String activity;
  String speaker;
  String description;
  int type;
  int subtype;
  int status;
  String hourIni;
  String hourFin;

  Activity();

  Activity.map(dynamic obj) {
    this.id = obj["id"];
    this.capacitySite = obj["capacity_site"];
    this.activity = obj["activity"];
    this.speaker = obj["speaker"];
    this.description = obj["description"];
    this.type = obj["type"];
    this.subtype = obj["subtype"];
    this.status = obj["status"];
    this.hourIni = obj["hour_ini"];
    this.hourFin = obj["hour_fin"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "capacity_site": this.capacitySite,
      "activity": this.activity,
      "speaker": this.speaker,
      "description": this.description,
      "type": this.type,
      "subtype": this.subtype,
      "status": this.status,
      "hour_ini": this.hourIni,
      "hour_fin": this.hourFin,
    };
  }

  Future<Activity> first({int id}) async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;
    var res = await client.query(tableName,
      where: "id = ?",
      whereArgs: [id ?? this.id],
    );

    if (res.length <= 0) {
      return null;
    }

    return Activity.map(res.first);

  }

  Future<List<Activity>> get() async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;
    var res = await client.query(tableName);

    if (res.length <= 0) {
      return null;
    }
    
    List<Activity> activities = [];
    for (var activity in res) {
      activities.add(Activity.map(activity));
    }
    return activities;

  }

  // Updates the activity in the database
  Future<bool> save() async {
    
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    var res = await client.update(tableName, this.toMap(), 
      where: "id = ?",
      whereArgs: [this.id],
    );

    if(res == null) return false;

    return true;

  }

  // Inserts the activity in the database
  Future<bool> insert() async {
    
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    var res = await client.insert(tableName, this.toMap());

    if(res == null) return false;

    return true;
    
  }
}