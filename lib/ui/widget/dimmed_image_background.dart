import 'package:flutter/material.dart';

import 'blurred_background.dart';
import 'dimmed_background.dart';

class DimmedImageBackground extends StatefulWidget {
  final ImageProvider image;
  final bool shouldBlur;
  final bool shouldAnimate;
  final Duration animationDuration;

  const DimmedImageBackground({
    super.key,
    required this.image,
    this.shouldBlur = false,
    this.shouldAnimate = false,
    this.animationDuration = const Duration(milliseconds: 0),
  });

  @override
  DimmedImageBackgroundState createState() => DimmedImageBackgroundState();
}

class DimmedImageBackgroundState extends State<DimmedImageBackground>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundBlurAnimationController =
      AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );
  late final Animation<double> _backgroundBlurAnimation = CurvedAnimation(
    parent: _backgroundBlurAnimationController,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.shouldAnimate) _backgroundBlurAnimationController.forward();
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (widget.shouldBlur)
          BlurredBackground(
            backgroundAnimation: _backgroundBlurAnimation,
          ),
        FadeTransition(
          opacity: _backgroundBlurAnimation,
          child: _buildDimmedImageBackground(),
        )
      ],
    );
  }

  Widget _buildDimmedImageBackground() {
    return DimmedBackground(
      colors: [
        Colors.black.withOpacity(0.2),
        Colors.black,
      ],
      stops: const [0.0, 1.0],
    );
  }

  @override
  void dispose() {
    _backgroundBlurAnimationController.dispose();
    super.dispose();
  }
}
