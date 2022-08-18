import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImgUtils {
  ImgUtils._();

  static Future<Uint8List?> pickImage() async {
    final picker = ImagePicker();
    final xFileImg = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (xFileImg == null) return null;
    return cropImg(xFileImg.path);
  }

  static Future<Uint8List> compressImg(Uint8List imgUL) async {
    imgUL = await FlutterImageCompress.compressWithList(
      imgUL,
      quality: 5,
    );
    return imgUL;
  }

  static Future<Uint8List?> cropImg(String path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Get.theme.colorScheme.background,
          toolbarWidgetColor: Get.theme.colorScheme.secondary,
          cropFrameColor: Get.theme.colorScheme.primary,
          cropFrameStrokeWidth: 5,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          showCropGrid: false,
          hideBottomControls: true,
        ),
        WebUiSettings(
          context: Get.context!,
        ),
      ],
    );
    return croppedFile?.readAsBytes();
  }
}
