import 'package:expotenderos_app/models/Activity.dart';
import 'package:expotenderos_app/models/Combo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComboTile extends StatelessWidget {

  final Combo combo;
  final Function onTap;
  final bool enabled;
  final bool activities;

  ComboTile(this.combo, {this.onTap, this.enabled = true, this.activities = true});
  
  @override
  Widget build(BuildContext context) {
    
    DateFormat format = DateFormat('h:mm a');
    var time = DateTime.parse('2019-07-27 ' + combo.hour);

    return ListTile(
      title: Text("${combo.name}"),
      subtitle: activities ? Column(
        children: combo.activities.map((activity) => ActivityContainer(activity)).toList(),
      ) : null,
      trailing: Text("${format.format(time)}"),
      enabled: enabled,
      onTap: onTap,
    );
  }
}

class ActivityContainer extends StatelessWidget {

  final Activity activity;

  ActivityContainer(this.activity);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "${activity.activity} - ${activity.description}"
      ),
    );
  }
}