import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ocr/Screen/recognization_page.dart';

Future<String> imageCropperView(String? path, BuildContext context) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path!,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
     
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Color.fromARGB(255, 6, 240, 56),
          initAspectRatio: CropAspectRatioPreset.original,
cropFrameStrokeWidth:0,
          
// activeControlsWidgetColor: Color.fromARGB(255, 26, 6, 202),
// dimmedLayerColor: Color.fromARGB(255, 174, 15, 132),

   cropFrameColor: Color.fromARGB(255, 224, 5, 5),
showCropGrid:true,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Crop Image',
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );

  if (croppedFile != null) {
    log("Image cropped");
    return croppedFile.path;
  } else {
    log("Do nothing");
    return '';
  }
}
