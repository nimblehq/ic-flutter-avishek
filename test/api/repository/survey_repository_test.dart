import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/api/repository/survey_repository.dart';
import 'package:flutter_survey/model/response/survey_list_response.dart';
import 'package:flutter_survey/model/response/survey_response.dart';
import 'package:flutter_survey/model/survey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/generate_mocks.mocks.dart';

void main() {
  FlutterConfig.loadValueForTesting({
    'CLIENT_ID': 'CLIENT_ID',
    'CLIENT_SECRET': 'CLIENT_SECRET',
  });

  final surveyResponses =
      SurveyListResponse(data: [SurveyResponse(id: "1234")]);
  final surveys =
      surveyResponses.data.map((e) => Survey.fromSurveyResponse(e)).toList();

  group("SurveyRepository", () {
    MockSurveyService mockSurveyService = MockSurveyService();
    MockLocalStorage mockLocalStorage = MockLocalStorage();
    late SurveyRepository surveyRepository;

    setUp(() {
      when(mockLocalStorage.surveys).thenAnswer((_) async => surveys);
      when(mockSurveyService.getSurveys(any, any))
          .thenAnswer((_) async => surveyResponses);

      surveyRepository =
          SurveyRepositoryImpl(mockSurveyService, mockLocalStorage);
    });

    test(
        "When fetching the surveys successfully, it emits the corresponding value",
        () async {
      expect(
        surveyRepository.getSurveys(1, 5, false),
        emitsInOrder([
          surveys,
          surveys,
        ]),
      );
    });

    test(
        "When fetching the surveys for the first time successfully, it emits the corresponding value",
        () async {
      expect(
        surveyRepository.getSurveys(1, 5, false),
        emitsInOrder([
          surveys,
          surveys,
        ]),
      );
      verify(mockLocalStorage.clearCachedSurveys()).called(1);
    });

    test(
        "When refreshing the surveys successfully, it emits the corresponding value",
        () async {
      expect(
        surveyRepository.getSurveys(1, 5, true),
        emitsInOrder([
          surveys,
        ]),
      );
    });

    test(
        "When fetching more surveys successfully, it emits the corresponding value",
        () async {
      expect(
        surveyRepository.getSurveys(2, 5, false),
        emitsInOrder([
          surveys,
        ]),
      );
    });

    test("When fetching the surveys fails, it emits the corresponding error",
        () async {
      when(mockLocalStorage.surveys).thenAnswer((_) async => []);
      when(mockSurveyService.getSurveys(any, any))
          .thenThrow(MockDioException());

      surveyRepository.getSurveys(1, 5, false).listen((result) {
        expect(result, isA<NetworkExceptions>());
      });
    });
  });
}
