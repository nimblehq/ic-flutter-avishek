import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/response/survey_list_response.dart';

part 'survey_service.g.dart';

abstract class BaseSurveyService {
  Future<SurveyListResponse> getSurveys(
    @Path('pageNumber') int pageNumber,
    @Path('pageSize') int pageSize,
  );
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
}
