import 'dart:math';

String generateSuffix() {
  return "${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}";
}

class DeviceEntity {
  final String id;
  final String userLoginId;
  final String deviceType;
  final String deviceInfor;
  final int lastActiveAt;

  DeviceEntity({
    String? id,
    required this.userLoginId,
    required this.deviceType,
    required this.deviceInfor,
    required this.lastActiveAt,
  }) : id = id ?? 'device_${generateSuffix()}';

  factory DeviceEntity.fromJson(Map<String, dynamic> json) {
    return DeviceEntity(
      id: json['id'],
      userLoginId: json['userLoginId'],
      deviceType: json['deviceType'],
      deviceInfor: json['deviceInfor'],
      lastActiveAt: json['lastActiveAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userLoginId': userLoginId,
      'deviceType': deviceType,
      'deviceInfor': deviceInfor,
      'lastActiveAt': lastActiveAt,
    };
  }

  DeviceEntity copyWith({
    String? id,
    String? userLoginId,
    String? deviceType,
    String? deviceInfor,
    int? lastActiveAt,
  }) {
    return DeviceEntity(
      id: id ?? this.id,
      userLoginId: userLoginId ?? this.userLoginId,
      deviceType: deviceType ?? this.deviceType,
      deviceInfor: deviceInfor ?? this.deviceInfor,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  String toString() {
    return 'DeviceEntity(id: $id, userLoginId: $userLoginId, deviceType: $deviceType, deviceInfor: $deviceInfor, lastActiveAt: $lastActiveAt)';
  }
}

class MessageEntity {
  final String id;
  final String roomId;
  final String senderId;
  final String type;
  final String? text;
  final String? mediaUrl;
  final int timestamp;
  final List<String> seenBy;
  final List<ReactionEntity> reactions;
  final String? replyToMessageId;
  final List<String> deletedForUsers;

  MessageEntity({
    String? id,
    required this.roomId,
    required this.senderId,
    required this.type,
    this.text,
    this.mediaUrl,
    int? timestamp,
    List<String>? seenBy,
    List<ReactionEntity>? reactions,
    this.replyToMessageId,
    List<String>? deletedForUsers,
  })  : id = id ?? 'message_${generateSuffix()}',
        timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch,
        seenBy = seenBy ?? [],
        reactions = reactions ?? [],
        deletedForUsers = deletedForUsers ?? [];

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'],
      roomId: json['roomId'],
      senderId: json['senderId'],
      type: json['type'],
      text: json['text'],
      mediaUrl: json['mediaUrl'],
      timestamp: json['timestamp'],
      seenBy: List<String>.from(json['seenBy'] ?? []),
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => ReactionEntity.fromJson(e))
              .toList() ??
          [],
      replyToMessageId: json['replyToMessageId'],
      deletedForUsers: List<String>.from(json['deletedForUsers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'type': type,
      'text': text,
      'mediaUrl': mediaUrl,
      'timestamp': timestamp,
      'seenBy': seenBy,
      'reactions': reactions.map((e) => e.toJson()).toList(),
      'replyToMessageId': replyToMessageId,
      'deletedForUsers': deletedForUsers,
    };
  }

  MessageEntity copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? type,
    String? text,
    String? mediaUrl,
    int? timestamp,
    List<String>? seenBy,
    List<ReactionEntity>? reactions,
    String? replyToMessageId,
    List<String>? deletedForUsers,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      text: text ?? this.text,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      timestamp: timestamp ?? this.timestamp,
      seenBy: seenBy ?? this.seenBy,
      reactions: reactions ?? this.reactions,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      deletedForUsers: deletedForUsers ?? this.deletedForUsers,
    );
  }

  @override
  String toString() {
    return 'MessageEntity(id: $id, roomId: $roomId, senderId: $senderId, type: $type, text: $text, mediaUrl: $mediaUrl, timestamp: $timestamp, seenBy: $seenBy, reactions: $reactions, replyToMessageId: $replyToMessageId, deletedForUsers: $deletedForUsers)';
  }

  // Factory method for creating a new message
  factory MessageEntity.from({
    required String roomId,
    required String senderId,
    required String type,
    String? text,
    String? mediaUrl,
    String? replyToMessageId,
  }) {
    return MessageEntity(
      id: 'message_${generateSuffix()}',
      roomId: roomId,
      senderId: senderId,
      type: type,
      text: text,
      mediaUrl: mediaUrl,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      seenBy: [],
      reactions: [],
      replyToMessageId: replyToMessageId,
      deletedForUsers: [],
    );
  }
}

class ReactionEntity {
  final String id;
  final String userId;
  final String emoji;

  ReactionEntity({
    String? id,
    String? userId,
    String? emoji,
  })  : id = id ?? '',
        userId = userId ?? 'user_${generateSuffix()}',
        emoji = emoji ?? 'none';

  factory ReactionEntity.fromJson(Map<String, dynamic> json) {
    return ReactionEntity(
      id: json['id'],
      userId: json['userId'],
      emoji: json['emoji'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'emoji': emoji,
    };
  }

  ReactionEntity copyWith({
    String? id,
    String? userId,
    String? emoji,
  }) {
    return ReactionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  String toString() {
    return 'ReactionEntity(id: $id, userId: $userId, emoji: $emoji)';
  }
}

class RoomEntity {
  final String roomId;
  final String roomName;
  final String roomType;
  final List<String> members;
  final List<String> admin;
  final String createdBy;
  final int createdAt;
  final MessageEntity? lastMessage;

  RoomEntity({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.members,
    required this.admin,
    required this.createdBy,
    required this.createdAt,
    this.lastMessage,
  });

  factory RoomEntity.fromJson(Map<String, dynamic> json) {
    print("RoomEntity.fromJson: ${json}");
    return RoomEntity(
      roomId: json['roomId'],
      roomName: json['roomName'],
      roomType: json['roomType'],
      members: List<String>.from(json['members'] ?? []),
      admin: List<String>.from(json['admin'] ?? []),
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      lastMessage: json['lastMessage'] != null
          ? MessageEntity.fromJson(json['lastMessage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'roomType': roomType,
      'members': members,
      'admin': admin,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'lastMessage': lastMessage?.toJson(),
    };
  }

  RoomEntity copyWith({
    String? roomId,
    String? roomName,
    String? roomType,
    List<String>? members,
    List<String>? admin,
    String? createdBy,
    int? createdAt,
    MessageEntity? lastMessage,
  }) {
    return RoomEntity(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      roomType: roomType ?? this.roomType,
      members: members ?? this.members,
      admin: admin ?? this.admin,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  String toString() {
    return 'RoomEntity(roomId: $roomId, roomName: $roomName, roomType: $roomType, members: $members, admin: $admin, createdBy: $createdBy, createdAt: $createdAt, lastMessage: $lastMessage)';
  }

  // Factory method for creating a new room
  factory RoomEntity.from({
    required String roomName,
    required List<String> members,
    required String roomType,
    required String createdBy,
  }) {
    return RoomEntity(
      roomId: 'room_${generateSuffix()}',
      roomName: roomName,
      roomType: roomType,
      members: members,
      admin: [createdBy],
      createdBy: createdBy,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      lastMessage: null,
    );
  }
}

class UserChatEntity {
  final String userLoginId;
  final String userChatId;
  final String userName;
  final String displayName;
  final String? avatarUrl;
  final String? email;
  final String? phoneNumber;
  final String status;
  final int lastSeen;
  final String? bio;
  final int createdAt;
  final List<String> friends;
  final List<String> blockedUsers;
  final List<String> silentGroups;
  final bool isActive;

  UserChatEntity({
    required this.userLoginId,
    String? userChatId,
    required this.userName,
    required this.displayName,
    this.avatarUrl,
    this.email,
    this.phoneNumber,
    String? status,
    int? lastSeen,
    this.bio,
    int? createdAt,
    List<String>? friends,
    List<String>? blockedUsers,
    List<String>? silentGroups,
    bool? isActive,
  })  : userChatId = userChatId ?? 'user_chat_${generateSuffix()}',
        status = status ?? 'offline',
        lastSeen = lastSeen ?? DateTime.now().millisecondsSinceEpoch,
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        friends = friends ?? [],
        blockedUsers = blockedUsers ?? [],
        silentGroups = silentGroups ?? [],
        isActive = isActive ?? true;

  factory UserChatEntity.fromJson(Map<String, dynamic> json) {
    return UserChatEntity(
      userLoginId: json['userLoginId'],
      userChatId: json['userChatId'],
      userName: json['userName'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      status: json['status'],
      lastSeen: json['lastSeen'],
      bio: json['bio'],
      createdAt: json['createdAt'],
      friends: List<String>.from(json['friends'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      silentGroups: List<String>.from(json['silentGroups'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userLoginId': userLoginId,
      'userChatId': userChatId,
      'userName': userName,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'status': status,
      'lastSeen': lastSeen,
      'bio': bio,
      'createdAt': createdAt,
      'friends': friends,
      'blockedUsers': blockedUsers,
      'silentGroups': silentGroups,
      'isActive': isActive,
    };
  }

  UserChatEntity copyWith({
    String? userLoginId,
    String? userChatId,
    String? userName,
    String? displayName,
    String? avatarUrl,
    String? email,
    String? phoneNumber,
    String? status,
    int? lastSeen,
    String? bio,
    int? createdAt,
    List<String>? friends,
    List<String>? blockedUsers,
    List<String>? silentGroups,
    bool? isActive,
  }) {
    return UserChatEntity(
      userLoginId: userLoginId ?? this.userLoginId,
      userChatId: userChatId ?? this.userChatId,
      userName: userName ?? this.userName,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      friends: friends ?? this.friends,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      silentGroups: silentGroups ?? this.silentGroups,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'UserChatEntity(userLoginId: $userLoginId, userChatId: $userChatId, userName: $userName, displayName: $displayName, avatarUrl: $avatarUrl, email: $email, phoneNumber: $phoneNumber, status: $status, lastSeen: $lastSeen, bio: $bio, createdAt: $createdAt, friends: $friends, blockedUsers: $blockedUsers, silentGroups: $silentGroups, isActive: $isActive)';
  }

  // Factory method for creating a new user chat
  factory UserChatEntity.from({
    required String userLoginId,
    required String displayName,
    required String email,
    required String phoneNumber,
    String? avatarUrl,
    String? bio,
  }) {
    return UserChatEntity(
      userLoginId: userLoginId,
      userChatId: 'user_chat_${generateSuffix()}',
      userName: displayName,
      displayName: displayName,
      avatarUrl: avatarUrl,
      email: email,
      phoneNumber: phoneNumber,
      status: 'online',
      lastSeen: DateTime.now().millisecondsSinceEpoch,
      bio: bio,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      friends: [],
      blockedUsers: [],
      silentGroups: [],
      isActive: true,
    );
  }
}

class TypeUserStatus {
  static const String ONLINE = "online";
  static const String OFFLINE = "offline";
  static const String AWAY = "away";
}

class UserLoginEntity {
  final String id;
  final String username;
  final String password;

  UserLoginEntity({
    required this.id,
    required this.username,
    required this.password,
  });

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) {
    return UserLoginEntity(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  UserLoginEntity copyWith({
    String? id,
    String? username,
    String? password,
  }) {
    return UserLoginEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'UserLoginEntity(id: $id, username: $username, password: $password)';
  }
}
