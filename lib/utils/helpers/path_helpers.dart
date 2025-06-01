// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:printtosize/commons/constants.dart';

// class PathHelpers {
//   /// [inputPath]
//   ///
//   /// example:
//   ///
//   ///  * /storage/emulated/0/Pictures/FB_IMG_1726702895909.jpg
//   ///
//   ///  * /data/user/0/com.tapuniverse.resizephotos/cache/file_picker/1728008655196/1000000055.jpg
//   ///
//   /// Output Path with [format]:
//   ///
//   ///  example:
//   ///
//   ///  * /storage/emulated/0/Android/data/com.tapuniverse.resizephotos/files/FB_IMG_1726702895909.{format}
//   ///
//   static String generateExternalPath({
//     required Directory directory,
//     required String inputPath,
//     required String format,
//   }) {
//     String pathPrefix = directory.path;
//     String name = inputPath.split("/").last.split(".").first;
//     return "$pathPrefix/$name.${format.toLowerCase()}";
//   }

//   /// Return temp path:  storage/emulated/0/Android/data/com.tapuniverse.resizephotos/files/cropped_{index}.{format.toLowerCase()}
//   static Future<String> generateCroppedPath({
//     required int index,
//     String format = PNG,
//   }) async {
//     Directory? dic = (await getExternalStorageDirectory()) ??
//         (await getTemporaryDirectory());
//     String pathPrefix = dic.path;
//     return "$pathPrefix/cropped_$index.${format.toLowerCase()}";
//   }

//   static Future<String> generateResizedPath({
//     required String path,
//     String format = PNG,
//   }) async {
//     Directory dic = await getTemporaryDirectory();
//     String pathPrefix = dic.path;
//     String name = path.split("/").last.split(".").first;
//     return "$pathPrefix/resized_$name.${format.toLowerCase()}";
//   }

//   static Future<String> generateClonedPath({
//     required String path, 
//   }) async {
//     Directory dic = await getTemporaryDirectory();
//     String pathPrefix = dic.path;
//     String nameAndExtension = path.split("/").last;
//     return "$pathPrefix/cloned_$nameAndExtension";
//   }
// }
