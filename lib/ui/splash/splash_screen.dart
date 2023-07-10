import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../../theme/app_colors.dart';
import '../widget/dimmed_image_background.dart';
import '../widget/primary_text_form_field_decoration.dart';

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
        })
      ]),
    );
  }

  @override
  void dispose() {
    _logoRevealAnimationController.dispose();
    super.dispose();
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    const forgotButtonWidth = 80.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: PrimaryTextFormFieldDecoration(
            context: context,
            hint: AppLocalizations.of(context)!.email,
          ),
          keyboardType: TextInputType.emailAddress,
          style: Theme.of(context).textTheme.bodyLarge,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            TextFormField(
              decoration: PrimaryTextFormFieldDecoration(
                context: context,
                hint: AppLocalizations.of(context)!.password,
              ).copyWith(
                  contentPadding: const EdgeInsets.only(
                      left: 12,
                      right: forgotButtonWidth,
                      top: 15, // O:
                      bottom: 15 // use dimen constants
                      )),
              obscureText: true,
              obscuringCharacter: "●",
              style: Theme.of(context).textTheme.bodyLarge,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => {
                // TODO: log in
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 56,
                child: TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteAlpha50,
                        ),
                  ),
                  onPressed: () {
                    // TODO: navigate to reset password
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              overlayColor: MaterialStateProperty.all(Colors.black12),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.labelLarge,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.login),
            onPressed: () => {
              // TODO: log in
            },
          ),
        ),
      ],
    );
  }
}
