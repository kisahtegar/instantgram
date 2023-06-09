import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/auth/providers/user_id_provider.dart';
import '../../state/image_upload/models/file_type.dart';
import '../../state/image_upload/models/thumbnail_request.dart';
import '../../state/image_upload/providers/image_uploader_provider.dart';
import '../../state/post_settings/models/post_setting.dart';
import '../../state/post_settings/providers/post_setting_provider.dart';
import '../components/file_thumbnail_view.dart';
import '../constants/strings.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  const CreateNewPostView({
    super.key,
    required this.fileToPost,
    required this.fileType,
  });

  final File fileToPost;
  final FileType fileType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileType: widget.fileType,
    );
    final postSettings = ref.watch(postSettingProvider);
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);

    // use effect
    useEffect(
      () {
        void listener() {
          isPostButtonEnabled.value = postController.text.isNotEmpty;
        }

        postController.addListener(listener);

        return () {
          postController.removeListener(listener);
        };
      },
      // if postController change then rebuild useEffect.
      [postController],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.createNewPost,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isPostButtonEnabled.value
                ? () async {
                    // get the user id.
                    final userId = ref.read(userIdProvider);

                    if (userId == null) {
                      return;
                    }

                    // create a new post
                    final message = postController.text;
                    final isUploaded =
                        await ref.read(imageUploaderProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId,
                            );
                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // thumbnail
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),

            // Text message.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
                controller: postController,
              ),
            ),

            // Post Settings.
            ...PostSetting.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  // Default value switch is true.
                  value: postSettings[postSetting] ?? false,
                  onChanged: (isOn) {
                    ref.read(postSettingProvider.notifier).setSetting(
                          postSetting,
                          isOn,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
