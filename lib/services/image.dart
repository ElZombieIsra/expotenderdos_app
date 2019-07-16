// import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageHelper {

  ImageHelper();

  Future<File> getImage() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      return image;
    }
    return null;
  }
}