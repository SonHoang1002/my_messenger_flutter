import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_messenger_app_flu/config/api_config.dart';
import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';

class ChatRoomService {
  Future<List<MessageEntity>> getLastMessages(String roomId) async {
    String api = "${BASE_API}message/latest/$roomId";
    Response data = await ApiConfig().doGet(api);
    dynamic listMessageDatas = json.decode(data.body);
    List<MessageEntity> listMessageEntity = [];
    for (var element in listMessageDatas.reversed.toList()) {
      listMessageEntity.add(MessageEntity.fromJson(element));
    }
    return listMessageEntity;
  }

  Future<List<UserChatEntity>> getUsersChat(
    List<String> listUserChatInRoom,
  ) async {
    try {
      List<UserChatEntity> listUsers = [];
      for (var userChatId in listUserChatInRoom) {
        String api = "${BASE_API}user/$userChatId";
        print("userLoginId: $userChatId, api: $api");
        Response data = await ApiConfig().doGet(api);
        listUsers.add(UserChatEntity.fromJson(json.decode(data.body)));
      }
      return listUsers;
    } catch (e) {
      throw Exception("getUserChat error: ${e.toString()}");
    }
  }
}
