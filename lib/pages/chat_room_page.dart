import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';
import 'package:my_messenger_app_flu/services/chat_room_service.dart';
import 'package:my_messenger_app_flu/services/home_service.dart';
import 'package:my_messenger_app_flu/services/sockets/socket_chat_room.dart';

class ChatRoomPage extends StatefulWidget {
  final RoomEntity roomEntity;
  final UserChatEntity userChatEntity;

  const ChatRoomPage({
    super.key,
    required this.roomEntity,
    required this.userChatEntity,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  late SocketChatRoom _socketChatRoom;
  List<MessageEntity> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  late List<UserChatEntity> listUserInRoom;

  @override
  void initState() {
    super.initState();
    _socketChatRoom = SocketChatRoom(
      roomId: widget.roomEntity.roomId,
      userId: widget.userChatEntity.userChatId,
    );
    _socketChatRoom.connect();
    _listenToMessages();
    _fetchLastMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _socketChatRoom.disconnect();
    super.dispose();
  }

  Future<void> _fetchLastMessages() async {
    _messages =
        await ChatRoomService().getLastMessages(widget.roomEntity.roomId);
    setState(() {
      _isLoading = false;
    });
    List<String> listUserChatInRoom = widget.roomEntity.members.where(
      (element) {
        return element != widget.userChatEntity.userChatId;
      },
    ).toList();
    listUserInRoom = await ChatRoomService().getUsersChat(listUserChatInRoom);
  }

  void _listenToMessages() {
    _socketChatRoom.stream.listen((message) {
      final messageData = json.decode(message);

      setState(() {
        _messages.add(MessageEntity(
          roomId: messageData['roomId'],
          senderId: messageData['senderId'],
          type: messageData['type'],
          text: messageData['text'],
          mediaUrl: messageData['mediaUrl'],
          timestamp:
              messageData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
          seenBy: List<String>.from(messageData['seenBy'] ?? []),
          reactions: [],
          replyToMessageId: messageData['replyToMessageId'],
        ));
      });
      _scrollToBottom();
    }, onError: (error) {
      print('WebSocket error: $error');
      _socketChatRoom.reconnect();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = MessageEntity(
      roomId: widget.roomEntity.roomId,
      senderId: widget.userChatEntity.userChatId,
      type: 'text',
      text: _messageController.text,
      seenBy: [widget.userChatEntity.userChatId],
      reactions: [],
    );

    _socketChatRoom.sendMessage(message);
    _messageController.clear();
  }

  void onClose() {
    _socketChatRoom.reconnect();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onClose,
          ),
        ],
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildMessageBubble(MessageEntity message) {
    final isMe = message.senderId == widget.userChatEntity.userChatId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                'User ${message.senderId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            Text(message.text ?? ''),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Các hàm xử lý tùy chọn
  void _replyToMessage(MessageEntity message) {
    print('Trả lời tin nhắn: ${message.id}');
    // Thêm logic trả lời tin nhắn
  }

  void _copyMessage(MessageEntity message) {
    Clipboard.setData(ClipboardData(text: message.text ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép tin nhắn')),
    );
  }

  void _deleteMessage(MessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tin nhắn'),
        content: const Text('Bạn có chắc chắn muốn xóa tin nhắn này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Thêm logic xóa tin nhắn
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa tin nhắn')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _pinMessage(MessageEntity message) {
    print('Ghim tin nhắn: ${message.id}');
  }

  String _formatTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp)
        .toString()
        .substring(11, 16);
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
