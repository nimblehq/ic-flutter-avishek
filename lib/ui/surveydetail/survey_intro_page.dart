import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_screen.dart';

import '../../gen/assets.gen.dart';
import '../home/survey_ui_model.dart';

class SurveyIntroPage extends StatelessWidget {
  final SurveyUiModel survey;
  final Function() onNext;
  final Function() onClose;

  const SurveyIntroPage({
    super.key,
    required this.survey,
    required this.onNext,
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
        IconButton(
          key: SurveyDetailScreenKey.btBack,
          icon: Assets.icons.icBack.svg(fit: BoxFit.none),
          iconSize: 56,
          onPressed: onClose,
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
    return TextButton(
      key: SurveyDetailScreenKey.btStart,
      style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.black12,
          padding: const EdgeInsets.symmetric(vertical: 19),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: Theme.of(context).textTheme.labelLarge),
      onPressed: onNext,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(AppLocalizations.of(context)!.startSurvey),
      ),
    );
  }
}
