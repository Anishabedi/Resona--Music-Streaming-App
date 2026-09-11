import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart' ;
import 'package:flutter/material.dart';

String rgbToHex(Color color) {
  return '${(color.r * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.g * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.b * 255).round().toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex){
  return Color(int.parse(hex,radix:16) + 0xFF000000);
}
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
          content: Text(content)
      ),
    );
}

Future<File?> pickImage() async {
  try{
    final filePickerRes = await FilePicker.pickFiles(           // filepicker.platform.pickfiles
      type: FileType.image,
    );
    if(filePickerRes!= null){
      final pickedFilePath =  filePickerRes.files.first.path!;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFilePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    }
    return null;
  } catch (e){
    return null;
  }
}
Future<File?> pickAudio() async {
  try{
    final filePickerRes = await FilePicker.pickFiles(
      type: FileType.audio,
    );
    if(filePickerRes!= null){
      return File(filePickerRes.files.first.path!);
      // return File(filePickerRes!.files.first.xFile.path);
    }
    return null;
  } catch (e){
    return null;
  }
}

Color getAvatarColor(String name) {
  final colors = [
    Color(0xFF060e63),
    Color(0xFFfb6da8),
    Color(0xFFdea23a),
    Color(0xFF9a1be3),
    Color(0xFF7fe31b),
    Color(0xFF4DB6AC),
    Color(0xFFe31b50),
    Color(0xFF5C6BC0),
  ];

  int hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
  return colors[hash % colors.length];
}