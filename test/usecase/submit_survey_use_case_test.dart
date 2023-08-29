import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/submit_survey_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('SubmitSurveyUseCaseTest', () {
    late MockSurveyRepository mockRepository;
    late SubmitSurveyUseCase useCase;

    final input = SubmitSurveyInput(
      surveyId: "surveyId",
      questions: [],
    );

    setUp(() async {
      mockRepository = MockSurveyRepository();
      useCase = SubmitSurveyUseCase(mockRepository);
    });

    test('When calling the use case successfully, it returns Success result',
        () async {
      when(mockRepository.submitSurvey(any, any)).thenAnswer((_) async {});
      final result = await useCase.call(input);

      expect(result, isA<Success>());
    });

    test('When calling the use case unsuccessfully, it returns Failed result',
        () async {
      const expectedError = NetworkExceptions.unauthorisedRequest();
      when(mockRepository.submitSurvey(any, any)).thenAnswer((_) {
        return Future.error(
          expectedError,
        );
      });

      final result = await useCase.call(input);

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, expectedError);
    });
  });
}
