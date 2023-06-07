import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../state/comments/models/comment.dart';
import '../../../state/user_info/providers/user_info_model_provider.dart';
import '../animations/small_error_animation_view.dart';
import '../rich_two_parts_text.dart';

class CompactCommentTile extends ConsumerWidget {
  const CompactCommentTile({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.fromUserId,
      ),
    );

    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartsText(
          leftPart: userInfo.displayName,
          rightPart: comment.comment,
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
