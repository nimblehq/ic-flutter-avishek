import 'package:flutter_survey/model/response/question_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../api/response_converter.dart';

part 'survey_detail_response.g.dart';

@JsonSerializable()
class SurveyDetailResponse {
  final String id;
  final List<QuestionResponse> questions;

  SurveyDetailResponse({
    required this.id,
    required this.questions,
  });

  factory SurveyDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyDetailResponseFromJson(fromJsonApi(json));
}
