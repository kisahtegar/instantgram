import 'package:flutter/foundation.dart' show immutable;

import '../../posts/typedefs/user_id.dart';
import 'auth_result.dart';

@immutable
class AuthState {
  const AuthState({
    required this.userId,
    required this.result,
    required this.isLoading,
  });

  final UserId? userId;
  final AuthResult? result;
  final bool isLoading;

  // AuthState unkown
  const AuthState.unknown()
      : userId = null,
        result = null,
        isLoading = false;

  // AuthState copiedWithIsLoading
  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        userId: userId,
        result: result,
        isLoading: isLoading,
      );

  // Unique
  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (userId == other.userId &&
          result == other.result &&
          isLoading == other.isLoading);

  @override
  int get hashCode => Object.hash(
        userId,
        result,
        isLoading,
      );
}
