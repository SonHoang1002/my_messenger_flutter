import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_messenger_app_flu/config/api_config.dart';
import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';

class ChatRoomService {
  Future<List<MessageEntity>> getLastMessages(String roomId,
      {int limit = 10}) async {
    String api = "${BASE_API}message/latest/$roomId/${limit}";
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
        String api = "${BASE_API}user-chat/$userChatId";
        print("userLoginId: $userChatId, api: $api");
        Response data = await ApiConfig().doGet(api);
        listUsers.add(UserChatEntity.fromJson(json.decode(data.body)));
      }
      return listUsers;
    } catch (e) {
      throw Exception("getUserChat error: ${e.toString()}");
    }
  }

  Future<List<MessageEntity>> getMoreMessages(
    String roomId,
    int createAt, {
    int limit = 10,
  }) async {
    String api = "${BASE_API}message/more/$roomId/from/$createAt/limit/$limit";
    Response data = await ApiConfig().doGet(api);
    print("data.body: ${data.body}");
    dynamic listMessageDatas = json.decode(data.body);
    List<MessageEntity> listMessageEntity = [];
    for (var element in listMessageDatas.reversed.toList()) {
      listMessageEntity.add(MessageEntity.fromJson(element));
    }
    return listMessageEntity;
  }

  Future<bool> react(
    String messageId,
    int reactId,
  ) async {
    String api = "${BASE_API}message/react";
    var inputData = {
      "messageId": messageId,
      "reactId": reactId,
    };
    Response data = await ApiConfig().doPost(api, inputData);
    dynamic listMessageDatas = json.decode(data.body);
     
    return listMessageDatas;
  }
}
