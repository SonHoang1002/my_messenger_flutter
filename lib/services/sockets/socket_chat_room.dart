import 'dart:convert';

import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketChatRoom {
  static const String SOCKET_CHAT = BASE_WSS;
  late WebSocketChannel _channel;
  final String roomId;
  final String userId;

  SocketChatRoom({
    required this.roomId,
    required this.userId,
  });

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse(SOCKET_CHAT),
    );
  }

  void disconnect() {
    _channel.sink.close();
  }

  Stream get stream => _channel.stream;

  void sendMessage(MessageEntity message) {
    try {
      final messageJson = {
        'type': message.type,
        'roomId': message.roomId,
        'senderId': message.senderId,
        'text': message.text,
        'mediaUrl': message.mediaUrl,
        'replyToMessageId': message.replyToMessageId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      _channel.sink.add(json.encode(messageJson));
    } catch (e) {
      print('Error sending message: $e');
      reconnect();
    }
  }

  void reconnect() {
    disconnect(); 
  }
}