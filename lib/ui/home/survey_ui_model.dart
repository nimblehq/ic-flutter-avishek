import 'package:equatable/equatable.dart';
import 'package:flutter_survey/model/survey.dart';

import '../../model/question.dart';
import '../../model/survey_detail.dart';

class SurveyUiModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String coverImageUrl;
  final List<Question> questions;

  String get largeCoverImageUrl => "${coverImageUrl}l";

  const SurveyUiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    required this.questions,
  });

  factory SurveyUiModel.fromSurvey(Survey survey) {
    return SurveyUiModel(
      id: survey.id,
      title: survey.title,
      description: survey.description,
      coverImageUrl: survey.coverImageUrl,
      questions: const [],
    );
  }

  factory SurveyUiModel.fromSurveyDetail(
    SurveyUiModel survey,
    SurveyDetail surveyDetail,
  ) {
    return SurveyUiModel(
      id: survey.id,
      title: survey.title,
      description: survey.description,
      coverImageUrl: survey.coverImageUrl,
      questions: surveyDetail.questions,
    );
  }

  @override
  List<Object?> get props => [id, title, description, coverImageUrl, questions];
}
