import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../constants/firebase_collection_name.dart';
import '../../constants/firebase_field_name.dart';
import '../../posts/typedefs/user_id.dart';
import '../models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  /// Save User Info to collection
  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      // first check if we have this user's info from before
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(
            FirebaseFieldName.userId,
            isEqualTo: userId,
          )
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        // We already have this user's profile, save the new data instead
        // Updating...
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }

      // if we dont have this user's info from before, Create new user Collection
      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );
      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .add(payload);
      return true;
    } catch (_) {
      return false;
    }
  }
}
