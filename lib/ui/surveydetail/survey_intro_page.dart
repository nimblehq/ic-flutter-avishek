import 'package:flutter/material.dart';

import '../home/survey_ui_model.dart';

class SurveyIntroPage extends StatelessWidget {
  final SurveyUiModel survey;

  const SurveyIntroPage({
    super.key,
    required this.survey,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Widget _buildPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: _buildContent(context),
    );
  }

  Column _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          survey.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10.0),
        Text(
          survey.description,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white70),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
