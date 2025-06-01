import 'dart:convert';
import 'dart:math' as FrameRate;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_messenger_app_flu/components/dialogs/custom_dialog.dart';
import 'package:my_messenger_app_flu/components/reaction_button.dart';
import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';
import 'package:my_messenger_app_flu/services/chat_room_service.dart';
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
  final FocusNode _focusNode = FocusNode();
  late SocketChatRoom _socketChatRoom;
  List<MessageEntity> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingInit = true, _isLoadingMore = false, _hasMore = true;
  late List<UserChatEntity> listUserInRoom;

  String messageActionType = MessageActionType.CREATE_NEW_MESSAGE;
  MessageEntity? _focusingMessageEntity;
  MessageEntity? _hoveringMessage;

  final GlobalKey _keyReaction = GlobalKey(debugLabel: "_keyReaction");

  Offset? _startReactionOffset, _updateReactionOffset, _endReactionOffset;

  OverlayEntry? _reactionOverlayEntry;
  MessageEntity? _messageForReaction;
  String? _hoveredReaction;


  bool get isShowEntryOverlay => _reactionOverlayEntry != null;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerToScrollTop);
    _socketChatRoom = SocketChatRoom(
      roomId: widget.roomEntity.roomId,
      userId: widget.userChatEntity.userChatId,
    );
    _socketChatRoom.connect();
    _listenerToMessages();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _fetchLastMessages();
        print("listUserInRoom: $listUserInRoom");
      },
    );
  }

  @override
  void dispose() {
    _removeReactionOverlay();
    _messageController.dispose();
    _scrollController.dispose();
    _socketChatRoom.disconnect();
    super.dispose();
  }

  Future<void> _loadMorePreviousMessage() async {
    if (_messages.isEmpty) {
      return;
    }
    var roomId = widget.roomEntity.roomId;
    var createAt = _messages.first.createAt;
    var limit = 10;
    List<MessageEntity> listMessageMore =
        await ChatRoomService().getMoreMessages(roomId, createAt, limit: limit);
    _messages.insertAll(0, listMessageMore);
    if (listMessageMore.isEmpty) {
      _hasMore = false;
    } else {
      _hasMore = true;
    }
    setState(() {});
  }

  Future<void> _fetchLastMessages() async {
    _messages =
        await ChatRoomService().getLastMessages(widget.roomEntity.roomId);

    List<String> listUserChatInRoom =
        widget.roomEntity.members.where((element) {
      return element != widget.userChatEntity.userChatId;
    }).toList();
    listUserInRoom = await ChatRoomService().getUsersChat(listUserChatInRoom);

    setState(() {
      _isLoadingInit = false;
    });
  }

  void _listenerToMessages() {
    _socketChatRoom.stream.listen((message) {
      final messageData = json.decode(message);

      List<ReactionEntity> reactions = (messageData["reactions"] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ReactionEntity.fromJson(e))
              .toList() ??
          [];

      final newMessage = MessageEntity(
        id: messageData['id'] as String, // đảm bảo bạn có 'id' trong dữ liệu
        roomId: messageData['roomId'] as String,
        senderId: messageData['senderId'] as String,
        type: messageData['type'] as String,
        text: messageData['text'] as String?,
        mediaUrl: messageData['mediaUrl'] as String?,
        createAt:
            messageData['createAt'] ?? DateTime.now().millisecondsSinceEpoch,
        updateAt: messageData['updateAt'],
        seenBy: List<String>.from(messageData['seenBy'] ?? []),
        reactions: reactions,
        replyToMessageId: messageData['replyToMessageId'] as String?,
        deletedForUsers:
            List<String>.from(messageData['deletedForUsers'] ?? []),
      );
      print("newMessage from _listenToMessages: ${newMessage}");

      setState(() {
        final index = _messages.indexWhere((m) => m.id == newMessage.id);
        if (index == -1) {
          _messages.add(newMessage); // chưa có => thêm mới
          _scrollToBottom();
        } else {
          _messages[index] = newMessage; // đã có => cập nhật
        }
      });
    }, onError: (error) {
      print('WebSocket error: $error');
      _socketChatRoom.reconnect();
    });
  }

  void _listenerToScrollTop() async {
    if (_scrollController.position.pixels <= 0 && _hasMore) {
      setState(() {
        _isLoadingMore = true;
      });
      await _loadMorePreviousMessage();
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _isLoadingMore = false;
      });
    }
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

  void onCopyMessage(MessageEntity messageEntity) async {
    if (messageEntity.text == null) {
      const snackBar =
          SnackBar(content: Text('Copy action fail because text is empty!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    ClipboardData clipboardData = ClipboardData(text: messageEntity.text!);
    await Clipboard.setData(clipboardData);
    const snackBar = SnackBar(content: Text('Copy action is success!!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onEditMessage(MessageEntity messageEntity) {
    if (messageEntity.text == null) {
      const snackBar =
          SnackBar(content: Text('Copy action fail because text is empty!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    _messageController.text = messageEntity.text!;
    _focusingMessageEntity = messageEntity;
    _focusNode.requestFocus();
  }

  void onDeleteMessage(MessageEntity messageEntity) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              messageEntity.senderId == widget.userChatEntity.userChatId
                  ? ListTile(
                      leading:
                          const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Delete for everyone'),
                      onTap: () {
                        Navigator.pop(context);
                        _handleDeleteMessageForAll(messageEntity.id);
                      },
                    )
                  : SizedBox(),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete for you'),
                onTap: () {
                  Navigator.pop(context);
                  CustomDialog.showDialogConfirmDeleteForYou(
                    context,
                    messageEntity,
                    _handleDeleteMessageForYou,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCreateNewMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = MessageEntity(
      roomId: widget.roomEntity.roomId,
      senderId: widget.userChatEntity.userChatId,
      type: 'text',
      text: _messageController.text,
      seenBy: [widget.userChatEntity.userChatId],
      reactions: [],
    );
    final messageJson = {
      'type': message.type,
      'roomId': message.roomId,
      'senderId': message.senderId,
      'text': message.text,
      'mediaUrl': message.mediaUrl,
      'replyToMessageId': message.replyToMessageId,
      "messageActionType": MessageActionType.CREATE_NEW_MESSAGE,
    };

    _socketChatRoom.sendMessage(messageJson);
    _messageController.clear();
  }

  void _handleUpdateMessage(String messageId) {
    if (_messageController.text.trim().isEmpty) return;

    final messageJson = {
      'roomId': widget.roomEntity.roomId,
      'senderId': widget.userChatEntity.userChatId,
      'messageId': messageId,
      "messageActionType": MessageActionType.UPDATE_TEXT,
    };

    _socketChatRoom.sendMessage(messageJson);
    _messageController.clear();
  }

  void _handleDeleteMessageForYou(String messageId) {
    final messageJson = {
      'roomId': widget.roomEntity.roomId,
      'senderId': widget.userChatEntity.userChatId,
      'messageId': messageId,
      "messageActionType": MessageActionType.DELETE_MESSAGE,
      "delete_role": MessageDeleteRole.DELETE_WITH_ME,
    };

    _socketChatRoom.sendMessage(messageJson);
  }

  void _handleDeleteMessageForAll(String messageId) {
    final messageJson = {
      'roomId': widget.roomEntity.roomId,
      'senderId': widget.userChatEntity.userChatId,
      'messageId': messageId,
      "messageActionType": MessageActionType.DELETE_MESSAGE,
      "delete_role": MessageDeleteRole.DELETE_WITH_ALL,
    };

    _socketChatRoom.sendMessage(messageJson);
  }

  void _sendMessage() {
    if (messageActionType == MessageActionType.CREATE_NEW_MESSAGE) {
      _handleCreateNewMessage();
    } else if (messageActionType == MessageActionType.UPDATE_TEXT) {
      if (_focusingMessageEntity == null) {
        throw Exception("_focusingMessageEntity is not null");
      }
      _handleUpdateMessage(_focusingMessageEntity!.id);
    } else {}
  }

  void onClose() {
    _socketChatRoom.reconnect();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print("_startReactionOffset: $_startReactionOffset");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: _isLoadingInit
          ? CircularProgressIndicator()
          : Stack(
              children: [
                Column(
                  children: [
                    if (_isLoadingMore)
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          // Kiểm tra xem tin nhắn trước đó có cùng người gửi không
                          final isSameSenderAsPrevious = index > 0 &&
                              _messages[index - 1].senderId == message.senderId;
                          // Kiểm tra xem tin nhắn sau đó có cùng người gửi không
                          final isSameSenderAsNext = index <
                                  _messages.length - 1 &&
                              _messages[index + 1].senderId == message.senderId;

                          return _buildMessageBubble(
                            message,
                            isFirstInGroup: !isSameSenderAsPrevious,
                            isLastInGroup: !isSameSenderAsNext,
                          );
                        },
                      ),
                    ),
                    _buildMessageInput(),
                  ],
                ),
                if (isShowEntryOverlay)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        if (_reactionOverlayEntry != null &&
                            _reactionOverlayEntry!.mounted) {
                          _removeReactionOverlay();
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildMessageBubble(
    MessageEntity message, {
    required bool isFirstInGroup,
    required bool isLastInGroup,
  }) {
    final isMe = message.senderId == widget.userChatEntity.userChatId;
    bool isHideMessage =
        message.isHideMessage(widget.userChatEntity.userChatId);

    return StatefulBuilder(
      builder: (context, setState1) {
        bool isHovered = _hoveringMessage?.id == message.id;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: MouseRegion(
            onEnter: (_) {
              if (isHideMessage) {
                return;
              }
              setState1(() {
                _hoveringMessage = message;
              });
            },
            onExit: (_) {
              if (isHideMessage) {
                return;
              }
              setState1(() {
                _hoveringMessage = null;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                _buildMessageSetting(
                  isMe && isHovered && !isHideMessage,
                  message,
                ),
                GestureDetector(
                  onLongPress: () {
                    if (isHideMessage) {
                      return;
                    }
                    if (isMe) {
                      CustomDialog.showBottomDialogMessageOptionsWithOwner(
                        context,
                        message,
                        onCopyMessage: onCopyMessage,
                        onDeleteMessage: onDeleteMessage,
                        onEditMessage: onEditMessage,
                      );
                    } else {
                      CustomDialog.showBottomDialogMessageOptionsWithOther(
                        context,
                        message,
                        onCopyMessage: onCopyMessage,
                        onDeleteMessage: onDeleteMessage,
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: isFirstInGroup
                          ? 4
                          : 2, // Giảm khoảng cách trên nếu không phải là tin nhắn đầu
                      bottom: isLastInGroup
                          ? 4
                          : 2, // Giảm khoảng cách dưới nếu không phải là tin nhắn cuối
                      left: 8,
                      right: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isHideMessage
                          ? Colors.grey[100]
                          : (isMe ? Colors.blue[100] : Colors.grey[350]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isFirstInGroup ? 12 : 4),
                        topRight: Radius.circular(isFirstInGroup ? 12 : 4),
                        bottomLeft: Radius.circular(isLastInGroup ? 12 : 4),
                        bottomRight: Radius.circular(isLastInGroup ? 12 : 4),
                      ),
                    ),
                    child: isHideMessage
                        ? Text(
                            "Message is deleted!",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black45),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe &&
                                  isFirstInGroup) // Chỉ hiển thị tên nếu là tin nhắn đầu trong nhóm
                                Text(
                                  _getUserName(message),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              Text(message.text ?? ''),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(message.createAt) +
                                    (message.updateAt != null
                                        ? _formatTime(message.updateAt!)
                                        : ""),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                _buildMessageSetting(
                  !isMe && isHovered && !isHideMessage,
                  message,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageSetting(bool isShow, MessageEntity message) {
    return isShow
        ? Row(
            children: [
              // setting
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  CustomDialog.showBottomDialogMessageOptionsWithOwner(
                    context,
                    message,
                    onCopyMessage: onCopyMessage,
                    onDeleteMessage: onDeleteMessage,
                    onEditMessage: onEditMessage,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.settings, size: 16),
                ),
              ),
              // share
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.ios_share_outlined, size: 16),
                ),
              ),
              // reactions
              InkWell(
                key: _keyReaction,
                onTap: () {
                  print("onTap call");
                  _showReactionOverlay(context, message);
                },
                onTapDown: (details) {
                  print("onTapDown call");
                  _startReactionOffset = details.globalPosition;
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.emoji_emotions, size: 16),
                ),
              ),
            ],
          )
        : SizedBox();
  }
  
 
  Widget _buildReactionButton(
    String emojiGif,
    MessageEntity message,
    void Function(void Function()) rebuild, {
    bool isHovered = false,
    Size size = const Size(30, 30),
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    return MouseRegion(
      onEnter: (_) {
        _handleHover(true, emojiGif);
        rebuild(() {});
      },
      onExit: (_) {
        _handleHover(false, emojiGif);
        rebuild(() {});
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        // curve: Curves.easeOut,
        margin: EdgeInsets.symmetric(horizontal: 4),
        transform: Matrix4.identity()..scale(isHovered ? 1.5 : 1.0),
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        child: ReactionButton(
          emojiGif: emojiGif,
          onSelect: () {
            // Xử lý khi chọn reaction
            _handleReactionSelected(emojiGif, message);
            _removeReactionOverlay();
          },
          size: size,
          margin: margin,
        ),
      ),
    );
  }

  void _handleHover(bool isHovering, String emojiGif) {
    print("_handleHover call: $emojiGif");
    // setState(() {
    _hoveredReaction = isHovering ? emojiGif : null;
    // });
  }
  
  double _overlayOpacity = 0.0;
  bool _isOverlayVisible = false;

  void _showReactionOverlay(BuildContext context, MessageEntity message) {
    Size reactionBoxSize = Size(250, 45);
    Offset reactionOffset = _startReactionOffset!.translate(
      -reactionBoxSize.width / 2,
      -reactionBoxSize.height - 20,
    );
    _removeReactionOverlay();
    _messageForReaction = message;
    _reactionOverlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        
        builder: (context, setStateForOverlay) {
           if (!_isOverlayVisible) {
        _isOverlayVisible = true;
        Future.delayed(Duration.zero, () {
          setStateForOverlay(() {
            _overlayOpacity = 1.0;
          });
        });
      }
          return Positioned(
            left: reactionOffset.dx,
            top: reactionOffset.dy,
            child: Material(
              color: Colors.transparent,
              child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _overlayOpacity,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(90),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildReactionButton(
                        PATH_LIKE_GIF,
                        message,
                        setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_LIKE_GIF,
                      ),
                      _buildReactionButton(
                        PATH_LOVE_GIF,
                        message, setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_LOVE_GIF,
                        // size: const Size(45, 45),
                        // margin: EdgeInsets.only(bottom: 7),
                      ),
                      _buildReactionButton(
                        PATH_HAHA_GIF,
                        message, setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_HAHA_GIF,
                        // size: const Size(31, 31),
                        // margin: EdgeInsets.only(bottom: 1),
                      ),
                      _buildReactionButton(
                        PATH_WOW_GIF,
                        message, setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_WOW_GIF,
                        // size: const Size(27.5, 27.5),
                        // margin: EdgeInsets.only(bottom: 2),
                      ),
                      _buildReactionButton(
                        PATH_YAY_GIF,
                        message, setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_YAY_GIF,
                        // size: const Size(70, 70),
                        // margin: EdgeInsets.only(bottom: 10),
                      ),
                      _buildReactionButton(
                        PATH_SAD_GIF,
                        message, setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_SAD_GIF,
                        // size: const Size(28.5, 28.5),
                        // margin: EdgeInsets.only(bottom: 4),
                      ),
                      _buildReactionButton(
                        PATH_ANGRY_GIF,
                        message, setStateForOverlay,
                        isHovered: _hoveredReaction == PATH_ANGRY_GIF,
                        // size: const Size(28.5, 28.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    Overlay.of(context).insert(_reactionOverlayEntry!);
    setState(() {});
  }

  void _handleReactionSelected(String emoji, MessageEntity message) {
    // Gửi reaction lên server hoặc cập nhật local state
    // Ví dụ:
    // message.reaction = emoji;
    // setState(() {});
    // Hoặc gọi API:

    print('Reacted $emoji to message ${message.id}');
  }

  void _removeReactionOverlay() {
    if (_reactionOverlayEntry != null) {
      _reactionOverlayEntry?.remove();
      _reactionOverlayEntry = null;
      _messageForReaction = null;
      setState(() {});
    }
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
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                _sendMessage();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  String _getUserName(MessageEntity message) {
    for (var element in listUserInRoom) {
      if (element.userChatId == message.senderId) {
        return element.displayName;
      }
    }
    return 'User ${message.senderId}';
  }
}
