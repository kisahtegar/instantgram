import 'package:flutter/foundation.dart' show immutable;

import '../../../enums/date_sorting.dart';
import '../../posts/typedefs/post_id.dart';

@immutable
class RequestForPostAndComments {
  const RequestForPostAndComments({
    required this.postId,
    this.sortByCreatedAt = true,
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
  });

  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  // Equatable, using covariant just enforces that the incoming object of this type
  // and if it is not, it just throws an exception.
  @override
  bool operator ==(covariant RequestForPostAndComments other) =>
      postId == other.postId &&
      sortByCreatedAt == other.sortByCreatedAt &&
      dateSorting == other.dateSorting &&
      limit == other.limit;

  @override
  int get hashCode => Object.hashAll(
        [
          postId,
          sortByCreatedAt,
          dateSorting,
          limit,
        ],
      );
}
