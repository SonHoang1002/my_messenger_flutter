import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger_app_flu/providers/actions/action_user.dart';
import 'package:my_messenger_app_flu/providers/states/state_user.dart';

class BlocUserLogin extends Bloc<UserAction, UserState> {
  BlocUserLogin() : super(UserStateInit()) {
    // Xử lý action cập nhật toàn bộ
    on<UserActionUpdateAll>((event, emit) {
      emit(UserStateUpdate(
        refreshToken: event.refreshToken,
        token: event.token,
        userChatId: event.userChatId,
        userLoginId: event.userLoginId,
      ));
    });

    // Xử lý action cập nhật từng trường
    on<UserActionUpdateLoginId>((event, emit) {
      final currentState = state as UserStateUpdate;
      emit(UserStateUpdate(
        refreshToken: currentState.refreshToken,
        token: currentState.token,
        userChatId: currentState.userChatId,
        userLoginId: event.userLoginId,
      ));
    });

    on<UserActionUpdateChatId>((event, emit) {
      final currentState = state as UserStateUpdate;
      emit(UserStateUpdate(
        refreshToken: currentState.refreshToken,
        token: currentState.token,
        userChatId: event.userChatId,
        userLoginId: currentState.userLoginId,
      ));
    });

    on<UserActionUpdateToken>((event, emit) {
      final currentState = state as UserStateUpdate;
      emit(UserStateUpdate(
        refreshToken: currentState.refreshToken,
        token: event.token,
        userChatId: currentState.userChatId,
        userLoginId: currentState.userLoginId,
      ));
    });

    on<UserActionUpdateRefreshToken>((event, emit) {
      final currentState = state as UserStateUpdate;
      emit(UserStateUpdate(
        refreshToken: event.refreshToken,
        token: currentState.token,
        userChatId: currentState.userChatId,
        userLoginId: currentState.userLoginId,
      ));
    });

    // Xử lý action reset
    on<UserActionReset>((event, emit) {
      emit(UserStateInit());
    });
  }
}
