import 'package:equatable/equatable.dart';
import 'package:flutter_survey/model/question.dart';
import 'package:flutter_survey/model/response/survey_detail_response.dart';

class SurveyDetail extends Equatable {
  final List<Question> questions;

  const SurveyDetail({
    required this.questions,
  });

  @override
  List<Object?> get props => [questions];

  factory SurveyDetail.fromSurveyDetailResponse(SurveyDetailResponse response) {
    return SurveyDetail(
      questions: response.questions
          .map((e) => Question.fromQuestionResponse(e))
          .toList(),
    );
  }
}
