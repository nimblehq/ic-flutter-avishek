import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/model/survey.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/get_surveys_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group("GetSurveysUseCase", () {
    final MockSurveyRepository mockMockSurveyRepository =
        MockSurveyRepository();

    late GetSurveysUseCase getSurveysUseCase;

    setUp(() =>
        {getSurveysUseCase = GetSurveysUseCase(mockMockSurveyRepository)});

    test("When calling the use case successfully, it returns Success",
        () async {
      when(
        mockMockSurveyRepository.getSurveys(1, 5),
      ).thenAnswer((_) async => [
            const Survey(
                id: "1234",
                title: "title",
                description: "description",
                coverImageUrl: "coverImageUrl")
          ]);

      final result = await getSurveysUseCase
          .call(GetSurveysInput(pageNumber: 1, pageSize: 5));

      expect(result, isA<Success>());
    });

    test("When calling the use case unsuccessfully, it returns Failed",
        () async {
      when(
        mockMockSurveyRepository.getSurveys(1, 5),
      ).thenAnswer((_) =>
          Future.error(NetworkExceptions.fromDioException(MockDioException())));

      final result = await getSurveysUseCase
          .call(GetSurveysInput(pageNumber: 1, pageSize: 5));

      expect(result, isA<Failed>());
    });
  });
}
