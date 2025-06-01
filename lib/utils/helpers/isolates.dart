import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
class FlutterIsolates {
  // ignore: unused_element
  static Future<Map<String, dynamic>> _deleteAllFilesInDirectory(
    List<dynamic> args,
  ) async {
    SendPort resultPort = args[0];
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1][0]);
    Directory? directory = args[1][1];
    Map<String, dynamic> result = {
      "result": null,
    };
    List<String> listPath = [];
    try {
      if (directory != null) {
        if (directory.existsSync()) {
          for (var file in directory.listSync()) {
            if (file is File) {
              String path = file.path;
              await file.delete(recursive: true);
              listPath.add(path);
            }
          }
          result["result"] = listPath;
        }
      }
    } catch (e) {
      result["result"] = "error: $e";
    }

    Isolate.exit(resultPort, result);
  }
}
