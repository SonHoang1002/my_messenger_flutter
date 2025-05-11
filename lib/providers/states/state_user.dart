abstract class UserState {
  final String userLoginId;
  final String userChatId;
  final String token;
  final String refreshToken;
  UserState({
    required this.userLoginId,
    required this.refreshToken,
    required this.token,
    required this.userChatId,
  });
}

class UserStateInit extends UserState {
  UserStateInit()
      : super(
          userLoginId: "",
          userChatId: "",
          refreshToken: "",
          token: "",
        );
}

class UserStateUpdate extends UserState {
  final String userLoginId;
  final String userChatId;
  final String token;
  final String refreshToken;

  UserStateUpdate({
    required this.refreshToken,
    required this.token,
    required this.userChatId,
    required this.userLoginId,
  }) : super(
          refreshToken: refreshToken,
          token: token,
          userChatId: userChatId,
          userLoginId: userLoginId,
        );


  UserStateUpdate copyWith({
    String? userLoginId,
    String? userChatId,
    String? token,
    String? refreshToken,
  }) {
    return UserStateUpdate(
      refreshToken: refreshToken ?? this.refreshToken,
      token: token ?? this.token,
      userChatId: userChatId ?? this.userChatId,
      userLoginId: userLoginId ?? this.userLoginId,
    );
  }
}
