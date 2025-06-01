// import 'package:device_info_plus/device_info_plus.dart';

// class FlutterSdkDevice {
//   ///
//   /// androidInfo.version.sdkInt >= version;
//   ///
//   static Future<bool> checkSdk(int version) async {
//     return (await getCurrentSdk()) >= version;
//   }

//   static Future<int> getCurrentSdk() async {
//     AndroidDeviceInfo androidInfo = await getCurrentAndroidDeviceInfo();
//     return androidInfo.version.sdkInt;
//   }

//   static Future<AndroidDeviceInfo> getCurrentAndroidDeviceInfo() async {
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
//     return androidInfo;
//   }
// }
