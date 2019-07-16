import 'package:flutter/material.dart';

import 'package:expotenderos_app/models/Shopkeeper.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:location/location.dart';

class RegisterPresenter {

  Future<String> submit({
    @required GlobalKey<FormState> form,
    @required Shopkeeper shopkeeper
  }) async {
    if(!form.currentState.validate()) return "Rellene todos los campos";
    if(shopkeeper.type == null || shopkeeper.type < 0) return "Seleccione el tipo de tendero";
    if (!shopkeeper.privacy) return "Por favor acepte el acuerdo de privacidad";
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
    shopkeeper.shop.picture = "asdasd";
    shopkeeper.shop.location = await getCoordinates();

    shopkeeper.code = controllers[6].text;
    int id = await shopkeeper.save();
    return id;
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
      if (await location.hasPermission()) {
        return await location.getLocation();
      }
      else {
        location.requestPermission();
      }
    } catch (e) {
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

}