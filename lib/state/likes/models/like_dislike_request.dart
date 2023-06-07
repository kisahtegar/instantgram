import 'package:flutter/foundation.dart' show immutable;

import '../../posts/typedefs/post_id.dart';
import '../../posts/typedefs/user_id.dart';

@immutable
class LikeDislikeRequest {
  const LikeDislikeRequest({
    required this.postId,
    required this.likedBy,
  });

  final PostId postId;
  final UserId likedBy;
}
