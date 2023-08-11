import 'package:flutter/material.dart';
import 'package:flutter_survey/gen/assets.gen.dart';
import 'package:flutter_survey/model/question.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_survey/ui/surveydetail/survey_question_content.dart';

class SurveyQuestionPage extends StatelessWidget {
  final Question question;
  final int index;
  final int total;
  final Function() onNext;
  final Function() onClose;
  final Function() onSubmit;

  const SurveyQuestionPage({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.onNext,
    required this.onClose,
    required this.onSubmit,
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
              child: GestureDetector(
                key: SurveyDetailScreenKey.btClose,
                onTap: onClose,
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Assets.icons.icClose.svg(
                    fit: BoxFit.none,
                  ),
                ),
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
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            _buildActionButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return index < total
        ? Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              key: SurveyDetailScreenKey.btQuestionNext,
              onTap: onNext,
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
          )
        : TextButton(
            key: SurveyDetailScreenKey.btQuestionSubmit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              overlayColor: MaterialStateProperty.all(Colors.black12),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 19,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.labelLarge,
              ),
            ),
            onPressed: onSubmit,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(AppLocalizations.of(context)!.submitSurvey),
            ),
          );
  }
}
