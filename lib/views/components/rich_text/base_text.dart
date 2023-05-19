import 'package:flutter/foundation.dart' show immutable, VoidCallback;
import 'package:flutter/material.dart' show TextStyle, Colors, TextDecoration;

import 'link_text.dart';

@immutable
class BaseText {
  const BaseText({
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  /// Instance of BaseText for plain text.
  factory BaseText.plain({
    required String text,
    TextStyle? style = const TextStyle(),
  }) =>
      BaseText(
        text: text,
        style: style,
      );

  /// Instance of LinkText for link text.
  factory BaseText.link({
    required String text,
    required VoidCallback onTapped,
    TextStyle? style = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  }) =>
      LinkText(
        text: text,
        onTapped: onTapped,
        style: style,
      );
}
