// import 'package:permission_handler/permission_handler.dart';
// import 'package:printtosize/helpers/sdk_device.dart';

// class PermissionHelpers {
//   static Future<PermissionStatus> handleRequestPermission() async {
//     // Kiểm tra phiên bản SDK
//     bool isUsePhotoPermission = await FlutterSdkDevice.checkSdk(33);
//     PermissionStatus requestStatus = isUsePhotoPermission
//         ? await Permission.photos.request()
//         : await Permission.storage.request();
//     return requestStatus;
//   }

//   // static Future<PermissionStatus>
//   //     handleRequestPermissionWithPhotoManager() async {
//   // Kiểm tra phiên bản SDK

//   // PermissionState requestState = await PhotoManager.requestPermissionExtend(
//   //   requestOption: const PermissionRequestOption(
//   //     androidPermission: AndroidPermission(
//   //       type: RequestType.image,
//   //       mediaLocation: false,
//   //     ),
//   //   ),
//   // );
//   // switch (requestState) {
//   //   case PermissionState.authorized:
//   //     return PermissionStatus.granted;
//   //   case PermissionState.denied:
//   //     return PermissionStatus.denied;
//   //   case PermissionState.limited:
//   //     return PermissionStatus.limited;
//   //   default:
//   //     return PermissionStatus.permanentlyDenied;
//   // }
//   // }

//   static Future<PermissionStatus> getPermissionStatus() async {
//     // Kiểm tra phiên bản SDK
//     bool isUsePhotoPermission = await FlutterSdkDevice.checkSdk(33);
//     if (isUsePhotoPermission) {
//       return await Permission.photos.status;
//     } else {
//       return await Permission.storage.status;
//     }
//   }
// }
