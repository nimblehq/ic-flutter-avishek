import 'package:flutter/material.dart';
import 'package:flutter_survey/model/question.dart';
import 'package:flutter_survey/ui/surveydetail/survey_question_content.dart';

class SurveyQuestionPage extends StatelessWidget {
  final Question question;
  final int index;
  final int total;

  const SurveyQuestionPage({
    super.key,
    required this.question,
    required this.index,
    required this.total,
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
          "$index/$total",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 10.0),
        Text(
          question.text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Expanded(child: SizedBox.shrink()),
        Align(
          alignment: Alignment.center,
          child: SurveyQuestionContent(question: question),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
