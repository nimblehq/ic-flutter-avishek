import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
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
            GestureDetector(
              key: HomeScreenKey.btStartSurvey,
              onTap: () => {
                //TODO: navigate to the survey details screen.
              },
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Assets.icons.icArrowRight.svg(
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
