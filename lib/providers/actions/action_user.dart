abstract class UserAction {}

// Action cập nhật toàn bộ
class UserActionUpdateAll extends UserAction {
  final String userLoginId;
  final String userChatId;
  final String token;
  final String refreshToken;

  UserActionUpdateAll({
    required this.refreshToken,
    required this.token,
    required this.userChatId,
    required this.userLoginId,
  });
}

// Action cập nhật từng trường
class UserActionUpdateLoginId extends UserAction {
  final String userLoginId;
  UserActionUpdateLoginId(this.userLoginId);
}

class UserActionUpdateChatId extends UserAction {
  final String userChatId;
  UserActionUpdateChatId(this.userChatId);
}

class UserActionUpdateToken extends UserAction {
  final String token;
  UserActionUpdateToken(this.token);
}

class UserActionUpdateRefreshToken extends UserAction {
  final String refreshToken;
  UserActionUpdateRefreshToken(this.refreshToken);
}

// Action reset state
class UserActionReset extends UserAction {}