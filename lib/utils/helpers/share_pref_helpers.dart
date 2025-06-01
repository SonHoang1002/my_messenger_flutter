// import 'package:shared_preferences/shared_preferences.dart';

// class SharePrefHelpers {
//   static SharedPreferences? _pref;
//   static const String SHARE_PREF_MARGIN = "SHARE_PREF_MARGIN";

//   static const String SHARE_PREF_RULER = "SHARE_PREF_RULER";

//   static const String SHARE_PREF_SNAP = "SHARE_PREF_SNAP";

//   static Future<void> _init() async {
//     _pref ??= await SharedPreferences.getInstance();
//   }

//   static Future<List<String>> handleGetListSavedHexStringColor() async {
//     await _init();
//     return _pref!.getStringList(PREFERENCE_SAVED_COLOR_KEY) ?? [];
//   }

//   static Future<void> handleSetListSavedHexStringColor(
//     List<String> listColorHexString,
//   ) async {
//     await _init();
//     await _pref!.setStringList(PREFERENCE_SAVED_COLOR_KEY, listColorHexString);
//   }

//   static Future<void> handleSaveMarginStatus(bool value) async {
//     return saveBool(SHARE_PREF_MARGIN, value);
//   }

//   static Future<bool?> handleGetMarginStatus() async {
//     return getBool(SHARE_PREF_MARGIN);
//   }

//   static Future<void> handleSaveRulerStatus(bool value) async {
//     return saveBool(SHARE_PREF_RULER, value);
//   }

//   static Future<bool?> handleGetRulerStatus() async {
//     return getBool(SHARE_PREF_RULER);
//   }

//   static Future<void> handleSaveSnapStatus(bool value) async {
//     return saveBool(SHARE_PREF_SNAP, value);
//   }

//   static Future<bool?> handleGetSnapStatus() async {
//     return getBool(SHARE_PREF_SNAP);
//   }

//   static Future<void> saveBool(String key, bool value) async {
//     await _init();
//     await _pref!.setBool(key, value);
//   }

//   static Future<bool?> getBool(String key) async {
//     await _init();
//     return _pref!.getBool(key);
//   }
// }
