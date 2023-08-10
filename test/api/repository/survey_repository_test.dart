import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/api/repository/survey_repository.dart';
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

  group("SurveyRepository", () {
    MockSurveyService mockSurveyService = MockSurveyService();
    late SurveyRepository surveyRepository;

    setUp(() {
      surveyRepository = SurveyRepositoryImpl(mockSurveyService);
    });

    test(
        "When fetching the surveys successfully, it emits the corresponding value",
        () async {
      final surveyResponses = [SurveyResponse(id: "1234")];
      final expectedValue =
          surveyResponses.map((e) => Survey.fromSurveyResponse(e)).toList();

      when(mockSurveyService.getSurveys(any, any))
          .thenAnswer((_) async => surveyResponses);

      final result = await surveyRepository.getSurveys(1, 5);

      expect(result, expectedValue);
    });

    test("When fetching the surveys fails, it emits the corresponding error",
        () async {
      when(mockSurveyService.getSurveys(any, any))
          .thenThrow(MockDioException());

      result() => surveyRepository.getSurveys(1, 5);

      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });
}
