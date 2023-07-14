import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../di/di.dart';
import '../../gen/assets.gen.dart';
import '../../usecases/login_use_case.dart';
import '../widget/dimmed_image_background.dart';
import '../widget/loading_indicator.dart';
import '../widget/login_form.dart';
import 'login_state.dart';
import 'login_view_model.dart';

const _logoRevealDuration = Duration(milliseconds: 500);
const _logoDuration = Duration(milliseconds: 750);
const _loginFormRevealDuration = Duration(milliseconds: 700);

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(getIt.get<LoginUseCase>());
});

final _shouldAnimateLogoPositionProvider =
    StateProvider.autoDispose<bool>((_) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
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

  late final AnimationController _loginFormRevealAnimationController =
      AnimationController(
    duration: _loginFormRevealDuration,
    vsync: this,
  );
  late final Animation<double> _loginFormRevealAnimation = CurvedAnimation(
    parent: _loginFormRevealAnimationController,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginViewModelProvider, (_, loginState) {
      loginState.maybeWhen(
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.errorIncorrectUsernamePassword),
            ),
          );
        },
        success: () {
          // TODO: navigate to home
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Logged in successfully!")));
        },
        orElse: () {},
      );
    });
    return _buildLoginScreen();
  }

  Widget _buildLoginScreen() {
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
        ),
        Consumer(builder: (_, widgetRef, __) {
          final shouldRevealLoginForm =
              widgetRef.watch(_shouldAnimateLogoPositionProvider);
          if (shouldRevealLoginForm) {
            _loginFormRevealAnimationController.forward();
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _loginFormRevealAnimation,
              child: const LoginForm(),
            ),
          );
        }),
        Consumer(builder: (_, WidgetRef widgetRef, __) {
          final loginViewModel = widgetRef.watch(loginViewModelProvider);
          return loginViewModel.maybeWhen(
            loading: () => const LoadingIndicator(),
            orElse: () => const SizedBox.shrink(),
          );
        }),
      ]),
    );
  }

  @override
  void dispose() {
    _logoRevealAnimationController.dispose();
    super.dispose();
  }
}
