// import 'dart:convert';
// import 'package:my_messenger_app_flu/config/constant.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:flutter/foundation.dart';

// class SocketService with ChangeNotifier {
//   static const String _baseUrl = BASE_WSS;
//   late WebSocketChannel _globalChannel;
//   WebSocketChannel? _roomChannel;
//   String? _currentRoomId;
//   bool _isGlobalConnected = false;

//   // Kết nối global khi khởi tạo ứng dụng
//   void connectGlobal(String userId) {
//     if (_isGlobalConnected) return;
    
//     _globalChannel = WebSocketChannel.connect(
//       Uri.parse('$_baseUrl/global?userId=$userId'),
//     );

//     _globalChannel.stream.listen(
//       (data) => _handleGlobalEvent(data),
//       onError: (error) => _reconnectGlobal(userId),
//       onDone: () => _reconnectGlobal(userId),
//     );
    
//     _isGlobalConnected = true;
//   }

//   // Kết nối đến phòng cụ thể
//   void connectToRoom(String roomId, String userId) {
//     // Đóng kết nối phòng cũ nếu có
//     _roomChannel?.sink.close();
    
//     _currentRoomId = roomId;
//     _roomChannel = WebSocketChannel.connect(
//       Uri.parse('$_baseUrl/rooms/$roomId?userId=$userId'),
//     );

//     _roomChannel!.stream.listen(
//       (data) => _handleRoomEvent(data),
//       onError: (error) => _reconnectRoom(roomId, userId),
//       onDone: () => _reconnectRoom(roomId, userId),
//     );
//   }

//   void _handleGlobalEvent(dynamic data) {
//     final event = json.decode(data);
//     switch (event['type']) {
//       case 'room_update':
//         // Cập nhật danh sách phòng
//         notifyListeners();
//         break;
//       case 'new_message':
//         // Cập nhật last message và unread count
//         notifyListeners();
//         break;
//       case 'new_room':
//         // Thêm phòng mới vào danh sách
//         notifyListeners();
//         break;
//     }
//   }

//   void _handleRoomEvent(dynamic data) {
//     final message = json.decode(data);
//     // Chỉ thông báo nếu là phòng hiện tại
//     if (message['roomId'] == _currentRoomId) {
//       notifyListeners();
//     }
//   }

//   void _reconnectGlobal(String userId) {
//     _isGlobalConnected = false;
//     Future.delayed(const Duration(seconds: 3), () => connectGlobal(userId));
//   }

//   void _reconnectRoom(String roomId, String userId) {
//     Future.delayed(const Duration(seconds: 1), () => connectToRoom(roomId, userId));
//   }

//   void sendMessage(Map<String, dynamic> message) {
//     if (_roomChannel != null) {
//       _roomChannel!.sink.add(json.encode(message));
//     }
//   }

//   @override
//   void dispose() {
//     _globalChannel.sink.close();
//     _roomChannel?.sink.close();
//     super.dispose();
//   }
// }



