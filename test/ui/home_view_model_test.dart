import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/model/survey.dart';
import 'package:flutter_survey/ui/home/home_screen.dart';
import 'package:flutter_survey/ui/home/home_state.dart';
import 'package:flutter_survey/ui/home/home_view_model.dart';
import 'package:flutter_survey/ui/home/survey_ui_model.dart';
import 'package:flutter_survey/ui/login/login_screen.dart';
import 'package:flutter_survey/ui/login/login_state.dart';
import 'package:flutter_survey/ui/login/login_view_model.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/get_surveys_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

const surveys = [
  Survey(
      id: "1",
      title: "title",
      description: "description",
      coverImageUrl: "coverImageUrl"),
  Survey(
      id: "2",
      title: "title",
      description: "description",
      coverImageUrl: "coverImageUrl"),
  Survey(
      id: "3",
      title: "title",
      description: "description",
      coverImageUrl: "coverImageUrl"),
  Survey(
      id: "4",
      title: "title",
      description: "description",
      coverImageUrl: "coverImageUrl"),
  Survey(
      id: "5",
      title: "title",
      description: "description",
      coverImageUrl: "coverImageUrl"),
];

void main() {
  group('HomeViewModelTest', () {
    late MockGetSurveysUseCase mockGetSurveysUseCase;
    late ProviderContainer container;

    setUp(() {
      mockGetSurveysUseCase = MockGetSurveysUseCase();

      when(mockGetSurveysUseCase.call(any))
          .thenAnswer((_) async => Success(surveys));

      container = ProviderContainer(
        overrides: [
          homeViewModelProvider
              .overrideWithValue(HomeViewModel(mockGetSurveysUseCase)),
        ],
      );
      addTearDown(container.dispose);
    });

    test('When initializing, it emits accordingly', () {
      expect(container.read(homeViewModelProvider), const HomeState.success());
    });

    test('When initializing, it loads the surveys', () {
      final surveysStream =
          container.read(homeViewModelProvider.notifier).surveysStream;

      expect(
        surveysStream,
        emitsInOrder([
          surveys.map((survey) => SurveyUiModel.fromSurvey(survey)).toList(),
        ]),
      );
    });

    test(
        'When loading more surveys, it adds the newly loaded surveys to the existing ones',
        () {
      final surveysAfterLoadingMore = surveys + surveys;
      final surveysStream =
          container.read(homeViewModelProvider.notifier).surveysStream;

      container.read(homeViewModelProvider.notifier).loadSurveys();

      expect(
        surveysStream,
        emitsInOrder([
          surveys.map((survey) => SurveyUiModel.fromSurvey(survey)).toList(),
          surveysAfterLoadingMore
              .map((survey) => SurveyUiModel.fromSurvey(survey))
              .toList(),
        ]),
      );
    });

    test(
        'When refreshing the surveys, it loads surveys with the initial values',
        () {
      final surveysStream =
          container.read(homeViewModelProvider.notifier).surveysStream;

      container
          .read(homeViewModelProvider.notifier)
          .loadSurveys(shouldRefresh: true);

      expect(
        surveysStream,
        emitsInOrder([
          surveys.map((survey) => SurveyUiModel.fromSurvey(survey)).toList(),
          surveys.map((survey) => SurveyUiModel.fromSurvey(survey)).toList(),
        ]),
      );
    });

    test(
      'When loading surveys runs into an error, it emits values accordingly',
      () {
        const mockErrorMessage = "errorMessage";
        when(mockGetSurveysUseCase.call(any)).thenAnswer(
            (_) async => Failed(UseCaseException(Exception(mockErrorMessage))));
        final stateStream =
            container.read(homeViewModelProvider.notifier).stream;

        expect(
          stateStream,
          emitsInOrder([const HomeState.error(mockErrorMessage)]),
        );
        container.read(homeViewModelProvider.notifier).loadSurveys();
      },
    );

    test(
        'When loading more surveys with an index equal to threshold, it loads more surveys',
        () {
      final surveysStream =
          container.read(homeViewModelProvider.notifier).surveysStream;

      container.read(homeViewModelProvider.notifier).loadMoreSurveys(1);
      container.read(homeViewModelProvider.notifier).loadMoreSurveys(2);

      expect(
        surveysStream,
        emitsInOrder([
          surveys.map((survey) => SurveyUiModel.fromSurvey(survey)).toList(),
          (surveys + surveys)
              .map((survey) => SurveyUiModel.fromSurvey(survey))
              .toList(),
        ]),
      );
    });
  });
}
