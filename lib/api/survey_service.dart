import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/request/submit_survey_request.dart';
import '../model/response/survey_detail_response.dart';
import '../model/response/survey_list_response.dart';

part 'survey_service.g.dart';

abstract class BaseSurveyService {
  Future<SurveyListResponse> getSurveys(
    int pageNumber,
    int pageSize,
  );

  Future<SurveyDetailResponse> getSurveyDetail(String surveyId);

  Future<void> submitSurvey(@Body() SubmitSurveyRequest body);
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
  @GET('api/v1/surveys/{surveyId}')
  Future<SurveyDetailResponse> getSurveyDetail(
    @Path('surveyId') String surveyId,
  );

  @override
  @POST('api/v1/responses')
  Future<void> submitSurvey(@Body() SubmitSurveyRequest body);
}
