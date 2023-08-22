import 'package:flutter/material.dart';
import 'package:flutter_survey/gen/assets.gen.dart';
import 'package:flutter_survey/model/question.dart';
import 'package:flutter_survey/ui/surveydetail/survey_question_content.dart';

class SurveyQuestionPage extends StatelessWidget {
  final Question question;
  final int index;
  final int total;
  final Function() onClose;

  const SurveyQuestionPage({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Column _buildPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: onClose,
                icon: Assets.icons.icClose
                    .svg(fit: BoxFit.none, width: 56, height: 56),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildContent(context),
          ),
        ),
      ],
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
