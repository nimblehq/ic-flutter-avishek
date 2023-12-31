import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/get_survey_detail_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('GetSurveyDetailUseCaseTest', () {
    late MockSurveyRepository mockRepository;
    late GetSurveyDetailUseCase getSurveyDetailUseCase;

    setUp(() async {
      mockRepository = MockSurveyRepository();
      getSurveyDetailUseCase = GetSurveyDetailUseCase(mockRepository);
    });

    test('When calling the use case successfully, it returns Success',
        () async {
      final survey = MockSurveyDetail();

      when(mockRepository.getSurveyDetail(any)).thenAnswer((_) async => survey);
      final result = await getSurveyDetailUseCase.call(GetSurveyDetailInput(
        surveyId: "1",
      ));

      expect(result, isA<Success>());
    });

    test('When calling the use case unsuccessfully, it returns Failed',
        () async {
      when(mockRepository.getSurveyDetail(any)).thenAnswer((_) => Future.error(
            const NetworkExceptions.unauthorisedRequest(),
          ));
      final result = await getSurveyDetailUseCase.call(GetSurveyDetailInput(
        surveyId: "1",
      ));

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException,
          const NetworkExceptions.unauthorisedRequest());
    });
  });
}
