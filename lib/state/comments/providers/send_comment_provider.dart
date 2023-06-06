import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/send_comment_notifier.dart';
import '../../image_upload/typedefs/is_loading.dart';

final sendCommentProvider = StateNotifierProvider<SendCommentNotifier, IsLoading>((ref) => SendCommentNotifier(),);
