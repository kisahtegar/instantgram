import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'models/lottie_animation.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) => Lottie.asset(
        animation.fullpath,
        repeat: repeat,
        reverse: reverse,
      );
}

// Getting path folder where the animation located.
extension GetFullPath on LottieAnimation {
  String get fullpath => 'assets/animations/$name.json';
}
