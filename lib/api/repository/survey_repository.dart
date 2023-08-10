import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../local/local_storage.dart';
import '../../model/survey.dart';
import '../exception/network_exceptions.dart';
import '../survey_service.dart';

abstract class SurveyRepository {
  Stream<List<Survey>> getSurveys(
    int pageNumber,
    int pageSize,
    bool shouldRefresh,
  );
}

@LazySingleton(as: SurveyRepository)
class SurveyRepositoryImpl extends SurveyRepository {
  final SurveyService _surveyService;
  final LocalStorage _localStorage;

  final _surveyStreamController = StreamController<List<Survey>>.broadcast();

  SurveyRepositoryImpl(this._surveyService, this._localStorage);

  @override
  Stream<List<Survey>> getSurveys(
    int pageNumber,
    int pageSize,
    bool shouldRefresh,
  ) {
    if (shouldRefresh) {
      _localStorage.clearCachedSurveys();
    } else if (pageNumber == 1) {
      _getCachedSurveys();
    }
    _getRemoteSurveys(
      pageNumber,
      pageSize,
    );

    return _surveyStreamController.stream;
  }

  Future<void> _getRemoteSurveys(
    int pageNumber,
    int pageSize,
  ) async {
    try {
      final response = await _surveyService.getSurveys(
        pageNumber,
        pageSize,
      );
      final surveys =
          response.data.map((e) => Survey.fromSurveyResponse(e)).toList();
      _cacheSurveys(pageNumber, surveys);
      _surveyStreamController.sink.add(surveys);
    } catch (exception) {
      _surveyStreamController.sink
          .addError(NetworkExceptions.fromDioException(exception));
    }
  }

  Future<void> _getCachedSurveys() async {
    var surveys = await _localStorage.surveys;
    if (surveys.isNotEmpty) {
      _surveyStreamController.sink.add(surveys);
    }
  }

  void _cacheSurveys(int pageNumber, List<Survey> surveys) {
    if (pageNumber == 1) {
      _localStorage.clearCachedSurveys();
    }
    _localStorage.cacheSurveys(surveys);
  }
}
