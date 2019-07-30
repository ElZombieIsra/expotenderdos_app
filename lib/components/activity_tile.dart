import 'package:expotenderos_app/models/Activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityTile extends StatelessWidget {

  final Activity activity;
  final Function onTap;
  final bool enabled;

  ActivityTile(this.activity, {this.onTap, this.enabled = true});
  
  @override
  Widget build(BuildContext context) {
    
    DateFormat format = DateFormat('h:mm a');
    var time = DateTime.parse('2019-07-27 ' + activity.hourIni);
    return ListTile(
      title: Text("${activity.activity}"),
      subtitle: Text("${activity.speaker}"),
      trailing: Text("${format.format(time)}"),
      enabled: enabled,
      onTap: onTap,
    );
  }
}