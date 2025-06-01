import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_messenger_app_flu/utils/log_custom.dart';

class FlutterMethodChannel {
  static const platform = MethodChannel('com.tapuniverse.printtosize');

  static Future<List<int>?> resizeImageWithPathAndSize({
    required String path,
    required String outPath,
    required List<int> listWH,
    int quality = 95,
    bool isFlipHorizontal = false,
    bool isFlipVertical = false,
    int rotate = 0,
  }) async {
    try {
      Map<String, dynamic> data = {
        "path": path,
        "outPath": outPath,
        "quality": quality,
        "width": listWH[0],
        "height": listWH[1],
        "isFlipHorizontal": isFlipHorizontal,
        "isFlipVertical": isFlipVertical,
        "rotate": rotate,
      };

      List<Object?>? result =
          await platform.invokeMethod("resizeImageWithPathAndSize", data);
      return result?.cast<int>();
    } catch (e) {
      return null;
    }
  }

  static Future<List<int>?> resizeImageWithPathAndScale({
    required String path,
    required String outPath,
    required double scale,
    int quality = 95,
    bool isFlipHorizontal = false,
    bool isFlipVertical = false,
    int rotate = 0,
  }) async {
    try {
      Map<String, dynamic> data = {
        "path": path,
        "outPath": outPath,
        "quality": quality,
        "scale": scale,
        "isFlipHorizontal": isFlipHorizontal,
        "isFlipVertical": isFlipVertical,
        "rotate": rotate,
      };

      List<Object?>? result =
          await platform.invokeMethod("resizeImageWithPathAndSize", data);
      return result?.cast<int>();
    } catch (e) {
      return null;
    }
  }

  /// Return size of scaled image
  static Future<List<int>?> resizeImageWithPathAndMaxDimension({
    required String path,
    required String outPath,
    int maxDimension = 1000,
    int quality = 95,
    bool isFlipHorizontal = false,
    bool isFlipVertical = false,
    int rotate = 0,
  }) async {
    try {
      Map<String, dynamic> data = {
        "path": path,
        "outPath": outPath,
        "maxDimension": maxDimension,
        "quality": quality,
        "isFlipHorizontal": isFlipHorizontal,
        "isFlipVertical": isFlipVertical,
        "rotate": rotate,
      };

      List<Object?>? result = await platform.invokeMethod(
        "resizeImageWithPathAndMaxDimension",
        data,
      );
      consolelog("resizeImageWithPathAndMaxDimension: ${result}");
      return result?.cast<int>();
    } catch (e) {
      return null;
    }
  }



  static Future showToast(String message) async {
    Map<String, dynamic> nativeData = {
      "message": message,
    };
    return await platform.invokeMethod('showToast', nativeData);
  }

  static Future<List<String>?> getExifNative(
    String path,
  ) async {
    try {
      List<dynamic>? result = await platform.invokeMethod<List<dynamic>>(
        'getExifNative',
        [path],
      );

      return result?.cast<String>();
    } on PlatformException catch (e) {
      debugPrint("Error calling getExifNative: $e");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
    return null;
  }

  static Future<List<String?>> getDpiFromPath(String filePath) async {
    try {
      List args = [filePath];
      List<String?>? result = [];
      List<Object?> data = await platform.invokeMethod('getDpiFromPath', args);
      for (var i = 0; i < data.length; i++) {
        result.add(data[i].toString());
      }
      if (result.isEmpty) {
        throw Exception("getDpiFromPath error: result empty");
      }
      return result;
    } on PlatformException catch (e) {
      debugPrint("getDpiFromPath error: $e");
      return [];
    }
  }
}
