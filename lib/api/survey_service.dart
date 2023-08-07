import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/response/survey_detail_response.dart';
import '../model/response/survey_list_response.dart';

part 'survey_service.g.dart';

abstract class BaseSurveyService {
  Future<SurveyListResponse> getSurveys(
    int pageNumber,
    int pageSize,
  );

  Future<SurveyDetailResponse> getSurveyDetail(String surveyId);
}

@RestApi()
abstract class SurveyService extends BaseSurveyService {
  factory SurveyService(Dio dio, {String baseUrl}) = _SurveyService;

  @override
  @GET('api/v1/surveys?page[number]={pageNumber}&page[size]={pageSize}')
  Future<SurveyListResponse> getSurveys(
    @Path('pageNumber') int pageNumber,
    @Path('pageSize') int pageSize,
  );

  @override
  @GET('/v1/surveys/{surveyId}')
  Future<SurveyDetailResponse> getSurveyDetail(
    @Path('surveyId') String surveyId,
  );
}
