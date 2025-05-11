import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_messenger_app_flu/config/api_config.dart';
import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  final _storage = SharedPreferencesAsync();
  Future<UserChatEntity> getUserChat() async {
    try {
      String userLoginId = (await _storage.getString("userLoginId"))!;
      String api = "${BASE_API}user-chat/user-login/$userLoginId";
      print("userLoginId: $userLoginId, api: $api");
      Response data = await ApiConfig().doGet(api);
      return UserChatEntity.fromJson(json.decode(data.body));
    } catch (e) {
      throw Exception("getUserChat error: ${e.toString()}");
    }
  }

  Future<List<RoomEntity>> getRooms(String userChatId) async {
    try{
    String api = "${BASE_API}room/user/$userChatId";
    print("getRooms params: userLoginId: $userChatId, api: $api"); 
    Response data = await ApiConfig().doGet(api);
    var listRoomDatas =  json.decode(data.body);
    List<RoomEntity> listRoomEntity = [];
     for (var element in listRoomDatas) {
        listRoomEntity.add(RoomEntity.fromJson(element));
      }
      return listRoomEntity;
    } catch (e) {
      throw Exception("getRooms error: ${e.toString()}");
    }
  }
}
