import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
Color primary = Color(0xff6711B6);
Color semiBackground = Color(0xffDDBAFD);
Color secondary = Color(0xff8A2EDF);
Color textColor = Color(0xffE9D1FF);
Color headingColor = Color(0xff240045);

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<String> _extractText(InputImage inputImage) async {
  final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognisedText =
      await textDetector.processImage(inputImage);

  textDetector.close();
  return recognisedText.text;
}

Future<String> pickImageAndConvertText(
    ImageSource imagesource, BuildContext context) async {
  String text = "";
  try {
    if (imagesource == ImageSource.gallery) {
      final pickedFile = await ImagePicker().pickMultiImage();
      if (pickedFile == Null) throw "Image not selected";
      for (int i = 0; i < pickedFile!.length; i++) {
        InputImage inputImage = InputImage.fromFilePath(pickedFile[i].path);
        text += await _extractText(inputImage);
      }
    } else if (imagesource == ImageSource.camera) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile == Null) throw "Image not selected";
      InputImage inputImage = InputImage.fromFilePath(pickedFile!.path);
      text += await _extractText(inputImage);
    }
    return text;
  } catch (e) {
    showSnackBar(context, e.toString());
    return "";
  }
}

List<List<String>> convertPythonArrayStringToDart(String pythonArrayString) {
  // Use jsonDecode to parse the Python-like array string
  return (jsonDecode(pythonArrayString) as List)
      .map((e) => (e as List).map((item) => item.toString()).toList())
      .toList();
}
