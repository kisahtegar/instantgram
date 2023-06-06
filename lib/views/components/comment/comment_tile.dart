import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../state/auth/providers/user_id_provider.dart';
import '../../../state/comments/models/comment.dart';
import '../../../state/comments/providers/delete_comment_provider.dart';
import '../../../state/user_info/providers/user_info_model_provider.dart';
import '../animations/small_error_animation_view.dart';
import '../constants/strings.dart';
import '../dialogs/alert_dialog_model.dart';
import '../dialogs/delete_dialog.dart';

class CommentTile extends ConsumerWidget {
  const CommentTile({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch user information.
    final userInfo = ref.watch(
      userInfoModelProvider(comment.fromUserId),
    );

    // return user information when...
    return userInfo.when(
      data: (userInfo) {
        final currentUserId = ref.read(userIdProvider);

        return ListTile(
          trailing: currentUserId == comment.fromUserId
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    // Showing delete dialog.
                    final shouldDeleteComment = await const DeleteDialog(
                      titleOfObjectToDelete: Strings.comment,
                    ).present(context).then((value) => value ?? false);

                    // if true delete the comment.
                    if (shouldDeleteComment) {
                      await ref
                          .read(deleteCommentProvider.notifier)
                          .deleteComment(commentId: comment.id);
                    }
                  },
                )
              : null,
          title: Text(userInfo.displayName),
          subtitle: Text(comment.comment),
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
