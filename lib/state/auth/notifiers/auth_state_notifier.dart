import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../posts/typedefs/user_id.dart';
import '../../user_info/backend/user_info_storage.dart';
import '../backend/authenticator.dart';
import '../models/auth_result.dart';
import '../models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        userId: _authenticator.userId,
        result: AuthResult.success,
        isLoading: false,
      );
    }
  }

  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  /// `Future<void> logOut()` for auth state notifier.
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  /// `Future<void> loginWithGoogle()` for auth state notifier.
  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }

    // Change the state.
    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
    );
  }

  /// `Future<void> loginWithFacebook()` for auth state notifier.
  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }

    // Change the state.
    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.userId,
    );
  }

  /// `Future<void> saveUserInfo()` Save User Info to collection for auth state notifier.
  Future<void> saveUserInfo({
    required UserId userId,
  }) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );
}
