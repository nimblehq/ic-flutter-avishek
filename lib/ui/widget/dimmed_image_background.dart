import 'package:flutter/material.dart';

import 'blurred_background.dart';
import 'dimmed_background.dart';

class DimmedImageBackground extends StatefulWidget {
  final ImageProvider image;
  final bool shouldBlur;
  final Animation<double>? backgroundAnimation;

  const DimmedImageBackground({
    super.key,
    required this.image,
    this.shouldBlur = false,
    this.backgroundAnimation,
  });

  @override
  DimmedImageBackgroundState createState() => DimmedImageBackgroundState();
}

class DimmedImageBackgroundState extends State<DimmedImageBackground> {
  @override
  Widget build(BuildContext context) {
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
            backgroundAnimation: widget.backgroundAnimation,
          ),
        if (widget.backgroundAnimation != null)
          FadeTransition(
            opacity: widget.backgroundAnimation!,
            child: _buildDimmedImageBackground(),
          )
        else
          _buildDimmedImageBackground(),
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
}
