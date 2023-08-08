import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../gen/assets.gen.dart';
import '../../main.dart';
import '../home/home_screen.dart';
import '../home/survey_ui_model.dart';

class HomeFooter extends StatelessWidget {
  final SurveyUiModel survey;

  const HomeFooter({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          survey.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Text(
              survey.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            RawMaterialButton(
              key: HomeScreenKey.btStartSurvey,
              onPressed: () {
                context.pushNamed(
                  routePathSurveyDetailScreen,
                  extra: survey,
                );
              },
              elevation: 0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(15),
              shape: const CircleBorder(),
              child: Assets.icons.icArrowRight.svg(),
            ),
          ],
        ),
      ],
    );
  }
}
