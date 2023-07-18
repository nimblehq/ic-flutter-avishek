import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredBackground extends StatefulWidget {
  final Animation<double>? backgroundAnimation;

  const BlurredBackground({
    super.key,
    this.backgroundAnimation,
  });

  @override
  BlurredBackgroundState createState() => BlurredBackgroundState();
}

class BlurredBackgroundState extends State<BlurredBackground> {
  @override
  void initState() {
    widget.backgroundAnimation?.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sigma = (widget.backgroundAnimation?.value ?? 1) * 25.0;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        color: Colors.white10,
      ),
    );
  }
}
