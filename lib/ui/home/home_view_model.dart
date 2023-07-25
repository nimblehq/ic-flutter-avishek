import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/home/survey_ui_model.dart';
import 'package:rxdart/subjects.dart';

import '../../model/survey.dart';
import '../../usecases/base/base_use_case.dart';
import '../../usecases/get_surveys_use_case.dart';
import 'home_state.dart';
import 'home_state.dart';
import 'home_state.dart';
import 'home_state.dart';

const _defaultPageSize = 5;
const _loadMoreThreshold = 2;

class HomeViewModel extends StateNotifier<HomeState> {
  final GetSurveysUseCase _getSurveysUseCase;

  HomeViewModel(
    this._getSurveysUseCase,
  ) : super(const HomeState.init()) {
    loadSurveys();
  }

  int _page = 1;
  int _lastSelectedIndex = 0;

  final BehaviorSubject<List<SurveyUiModel>> _surveysSubject =
      BehaviorSubject();

  Stream<List<SurveyUiModel>> get surveysStream => _surveysSubject.stream;

  final BehaviorSubject<int> _surveyPageIndexSubject = BehaviorSubject();

  Stream<int> get surveyPageIndexStream => _surveyPageIndexSubject.stream;

  void loadSurveys({bool shouldRefresh = false}) async {
    if (shouldRefresh) {
      _page = 1;
      _surveyPageIndexSubject.add(0);
    }
    final result = await _getSurveysUseCase.call(GetSurveysInput(
      pageNumber: _page,
      pageSize: _defaultPageSize,
    ));
    if (result is Success<List<Survey>>) {
      final uiModels = result.value
          .map((survey) => SurveyUiModel.fromSurvey(survey))
          .toList();
      if (_surveysSubject.hasValue && !shouldRefresh) {
        _surveysSubject.add(_surveysSubject.value + uiModels);
      } else {
        _surveysSubject.add(uiModels);
      }
      state = const HomeState.success();
    } else {
      _handleError(result as Failed);
    }
  }

  void loadMoreSurveys(int selectedIndex) {
    final lastItemIndex = _surveysSubject.value.length - 1;
    final thresholdIndex = lastItemIndex - _loadMoreThreshold;
    if (selectedIndex != thresholdIndex ||
        _lastSelectedIndex >= selectedIndex) {
      _lastSelectedIndex = selectedIndex;
      return;
    }
    _page = selectedIndex + 1;
    _lastSelectedIndex = selectedIndex;
    loadSurveys();
  }

  _handleError(Failed result) {
    state = HomeState.error(result.getErrorMessage());
  }

  @override
  void dispose() async {
    await _surveysSubject.close();
    await _surveyPageIndexSubject.close();
    super.dispose();
  }
}
