import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Image;

@immutable
class ImageWithAspectRatio {
  const ImageWithAspectRatio({
    required this.image,
    required this.aspectRatio,
  });

  final Image image;
  final double aspectRatio;
}
