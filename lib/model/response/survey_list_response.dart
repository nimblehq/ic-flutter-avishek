import 'package:flutter_survey/model/response/survey_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/response_converter.dart';

part 'survey_list_response.g.dart';

@JsonSerializable()
class SurveyListResponse {
  @JsonKey(name: 'data')
  final List<SurveyResponse> data;

  const SurveyListResponse({
    required this.data,
  });

  factory SurveyListResponse.fromJson(Map<String, dynamic> json) {
    return _$SurveyListResponseFromJson(fromRootJsonApi(json));
  }
}
