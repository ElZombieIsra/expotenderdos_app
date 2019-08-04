import 'package:expotenderos_app/models/Combo.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:location/location.dart';
import 'package:expotenderos_app/services/image.dart';

class RegisterPresenter {

  Future<String> submit({
    @required GlobalKey<FormState> form,
    @required Shopkeeper shopkeeper
  }) async {
    if(!form.currentState.validate()) return "Rellene todos los campos";
    if(shopkeeper.type == null || shopkeeper.type < 0) return "Seleccione el tipo de tendero";
    if (!shopkeeper.privacy) return "Por favor acepte el acuerdo de privacidad";
    if (shopkeeper.shop.picture == null) return "Agregue la fotografía de la tienda";
    form.currentState.save();
    return null;
  }

  Future<int> sendForm(List<TextEditingController> controllers, Shopkeeper shopkeeper) async {
    shopkeeper.name = controllers[0].text;
    shopkeeper.email = controllers[1].text;
    shopkeeper.phone = controllers[2].text;

    if (controllers[3].text.isNotEmpty) shopkeeper.age = int.parse(controllers[3].text);

    shopkeeper.shop.name = controllers[4].text;
    shopkeeper.shop.address = controllers[5].text;

    shopkeeper.shop.location = await getCoordinates();

    shopkeeper.code = controllers[6].text;
    shopkeeper.shop.postalCode = int.parse(controllers[7].text);

    if (controllers[8].text.isNotEmpty) shopkeeper.referredName = controllers[8].text;
    if (controllers[9].text.isNotEmpty) shopkeeper.referredCode = controllers[9].text;
    // print(shopkeeper.activities[0]);
    int id = await shopkeeper.save();
    return id;
  }

  Future<File> getPicture() async {
    File img = await ImageHelper().getImage();
    return img;
  }

  Future<String> readQrCode() async {
    try {
      String res = await QRCodeReader()
        .setAutoFocusIntervalInMs(500)
        .scan();
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<LocationData> getLocation() async {
    Location location = Location();
    try {
      if (!(await location.hasPermission())) {
        await location.requestPermission();
      }
      return await location.getLocation();
    } catch (e) {
      print(e);
    } 
    return null;
  }

  Future<String> getCoordinates() async {
    LocationData data = await getLocation();
    if (data != null) {
      return "${data.latitude}, ${data.longitude}";
    }
    return null;
  }

  Future<List<Combo>> getCombos() async {

    List<Combo> combos = [];

    for (var combo in await Combo().get()) { 
      combo.activities = await combo.getActivities();
      combos.add(combo);
    }

    print(combos[0].activities);
    return combos;

  }

  Future<Combo> getCurrentCombo(int id) async {

    Combo combo = await Combo().first(id: id);
    await combo.getActivities();
    return combo;

  }

}