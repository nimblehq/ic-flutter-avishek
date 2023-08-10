import 'package:injectable/injectable.dart';

import '../../model/survey.dart';
import '../exception/network_exceptions.dart';
import '../survey_service.dart';

abstract class SurveyRepository {
  Future<List<Survey>> getSurveys(int pageNumber, int pageSize);
}

@LazySingleton(as: SurveyRepository)
class SurveyRepositoryImpl extends SurveyRepository {
  final SurveyService _surveyService;

  SurveyRepositoryImpl(this._surveyService);

  @override
  Future<List<Survey>> getSurveys(int pageNumber, int pageSize) async {
    try {
      final response = await _surveyService.getSurveys(
        pageNumber,
        pageSize,
      );
      final surveys =
          response.map((e) => Survey.fromSurveyResponse(e)).toList();
      return surveys;
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }
}
