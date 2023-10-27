import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../../theme/app_colors.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blackRussian,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Lottie.asset(
            'assets/lottie-files/thank-you.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
            controller: _animationController,
            onLoaded: (composition) {
              _animationController
                ..duration = composition.duration
                ..forward();
            },
          ),
          Text(
            AppLocalizations.of(context)!.thanks,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 28.0),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
