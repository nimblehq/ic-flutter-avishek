import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/model/survey_detail.dart';
import 'package:flutter_survey/ui/home/survey_ui_model.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_screen.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_state.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_view_model.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('SurveyDetailViewModelTest', () {
    late MockGetSurveyDetailUseCase mockGetSurveyDetailUseCase;
    late ProviderContainer container;

    late SurveyDetail surveyDetail = const SurveyDetail(questions: []);
    late SurveyUiModel surveyUiModel = const SurveyUiModel(
      id: "1",
      title: "title",
      description: "description",
      coverImageUrl: "coverImageUrl",
      questions: [],
    );

    setUp(() async {
      mockGetSurveyDetailUseCase = MockGetSurveyDetailUseCase();
      container = ProviderContainer(
        overrides: [
          surveyDetailViewModelProvider.overrideWithValue(SurveyDetailViewModel(
            mockGetSurveyDetailUseCase,
          )),
        ],
      );

      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Success(surveyDetail));

      addTearDown(container.dispose);
    });

    test('When initializing, it initializes with the Init state', () {
      expect(container.read(surveyDetailViewModelProvider),
          const SurveyDetailState.init());
    });

    test('When fetching Survey details, it emits accordingly', () async {
      final stateStream =
          container.read(surveyDetailViewModelProvider.notifier).stream;
      final surveyStream =
          container.read(surveyDetailViewModelProvider.notifier).surveyStream;

      expect(
          stateStream,
          emitsInOrder([
            const SurveyDetailState.success(),
            const SurveyDetailState.loading(),
            const SurveyDetailState.success(),
          ]));
      expect(
          surveyStream,
          emitsInOrder([
            surveyUiModel,
            SurveyUiModel.fromSurveyDetail(
              surveyUiModel,
              surveyDetail,
            ),
          ]));

      container
          .read(surveyDetailViewModelProvider.notifier)
          .loadSurveyDetail(surveyUiModel);
    });

    test(
        'When fetching survey details unsuccessfully, it emits Failed state accordingly',
        () {
      final mockException = MockUseCaseException();
      when(mockException.actualException)
          .thenReturn(const NetworkExceptions.internalServerError());
      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Failed(mockException));
      final stateStream =
          container.read(surveyDetailViewModelProvider.notifier).stream;
      final surveyStream =
          container.read(surveyDetailViewModelProvider.notifier).surveyStream;

      expect(
          stateStream,
          emitsInOrder([
            const SurveyDetailState.success(),
            const SurveyDetailState.loading(),
            SurveyDetailState.error(
              NetworkExceptions.getErrorMessage(
                  const NetworkExceptions.internalServerError()),
            )
          ]));
      expect(
          surveyStream,
          emitsInOrder([
            surveyUiModel,
          ]));

      container
          .read(surveyDetailViewModelProvider.notifier)
          .loadSurveyDetail(surveyUiModel);
    });
  });
}
