import 'package:flutter_survey/model/survey.dart';

class SurveyUiModel {
  final String id;
  final String title;
  final String description;
  final String coverImageUrl;

  const SurveyUiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
  });

  factory SurveyUiModel.fromSurvey(Survey survey) {
    return SurveyUiModel(
      id: survey.id,
      title: survey.title,
      description: survey.description,
      coverImageUrl: survey.coverImageUrl,
    );
  }
}
