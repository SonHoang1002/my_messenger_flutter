// import 'package:android_id/android_id.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:printtosize/commons/constants.dart';

// class SettingHelpers {
//   /// Function wiil return picked images when user choose first item in setting popup (open from library)
//   ///
//   static Future<void> onChoose(String value) async {
//     int index = LIST_SETTING_TITLE.indexOf(value);
//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         await onAccessSetting();
//         break;
//       case 2:
//         await onShareApp();
//         break;
//       case 3:
//         await onFeedback();
//         break;
//       default:
//     }
//   }

//   static Future<bool> onAccessSetting() async {
//     try {
//       return await openAppSettings();
//     } catch (e) {
//       debugPrint("onAccessSetting error: $e");
//       rethrow;
//     }
//   }

//   static Future<void> onShareApp() async {
//     try {
//       await Share.shareUri(Uri.parse(SHARE_APP_LINK));
//     } catch (e) {
//       debugPrint("onShareApp error: $e");
//       rethrow;
//     }
//   }

//   static Future<void> onFeedback() async {
//     try {
//       var id = await const AndroidId().getId();
//       final Email email = Email(
//         subject: '$APP_NAME Feedback $id',
//         recipients: ['tapuniverse@gmail.com'],
//         isHTML: false,
//       );
//       await FlutterEmailSender.send(email);
//     } catch (e) {
//       debugPrint("onFeedback error: $e");
//       rethrow;
//     }
//   }

//   // ignore: unused_element
//   static Future<void> _onPrivacy() async {
//     try {
//       final Uri url = Uri.parse(LINK_POLICY);
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url);
//       } else {
//         throw Exception('Could not launch $url');
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromPixel: $e, StackTrace: $stackTrace');
//     }
//   }

//   static Future<void> onUpgradeToPro() async {
//     try {
      
//     } catch (e) {
//       debugPrint("onUpgradeToPro error: $e");
//       rethrow;
//     }
//   }
// }
