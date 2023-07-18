import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../widget/dimmed_image_background.dart';

const _logoRevealDuration = Duration(milliseconds: 500);
const _logoDuration = Duration(milliseconds: 750);
const _loginFormRevealDuration = Duration(milliseconds: 700);

final _shouldAnimateLogoPositionProvider =
    StateProvider.autoDispose<bool>((_) => false);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoRevealAnimationController =
      AnimationController(
    duration: _logoRevealDuration,
    vsync: this,
  )..forward();
  late final Animation<double> _logoRevealAnimation = CurvedAnimation(
    parent: _logoRevealAnimationController,
    curve: Curves.linear,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final shouldAnimateLogoPosition =
            ref.read(_shouldAnimateLogoPositionProvider.notifier);
        Future.delayed(_logoDuration, () {
          shouldAnimateLogoPosition.state = !shouldAnimateLogoPosition.state;
        });
      }
    });

  @override
  Widget build(BuildContext context) {
    return _buildSplashScreen();
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Consumer(builder: (_, widgetRef, __) {
          final shouldAnimateBlur =
              widgetRef.watch(_shouldAnimateLogoPositionProvider);
          return DimmedImageBackground(
            image: Assets.images.bgSplash.image().image,
            shouldBlur: true,
            shouldAnimate: shouldAnimateBlur,
            animationDuration: _loginFormRevealDuration,
          );
        }),
        Consumer(
          builder: (_, widgetRef, __) {
            final shouldAnimateLogoPosition =
                widgetRef.watch(_shouldAnimateLogoPositionProvider);
            return AnimatedPositioned(
              duration: _loginFormRevealDuration,
              curve: Curves.easeIn,
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              top: shouldAnimateLogoPosition ? -500 : 0.0,
              child: Center(
                child: AnimatedScale(
                  duration: _loginFormRevealDuration,
                  scale: shouldAnimateLogoPosition ? 0.83 : 1,
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _logoRevealAnimation,
                    child: SvgPicture.asset('assets/images/logo_white.svg'),
                  ),
                ),
              ),
            );
          },
        )
      ]),
    );
  }

  @override
  void dispose() {
    _logoRevealAnimationController.dispose();
    super.dispose();
  }
}
