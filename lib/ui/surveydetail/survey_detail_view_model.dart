import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_state.dart';
import 'package:rxdart/subjects.dart';

import '../../model/survey_detail.dart';
import '../../usecases/base/base_use_case.dart';
import '../../usecases/get_survey_detail_use_case.dart';
import '../home/survey_ui_model.dart';

class SurveyDetailViewModel extends StateNotifier<SurveyDetailState> {
  final GetSurveyDetailUseCase _getSurveyDetailUseCase;

  SurveyDetailViewModel(
    this._getSurveyDetailUseCase,
  ) : super(const SurveyDetailState.init());

  final BehaviorSubject<SurveyUiModel> _surveySubject = BehaviorSubject();

  Stream<SurveyUiModel> get surveyStream => _surveySubject.stream;

  Future<void> loadSurveyDetail(SurveyUiModel surveyUiModel) async {
    _surveySubject.add(surveyUiModel);
    state = const SurveyDetailState.success();

    state = const SurveyDetailState.loading();
    final result = await _getSurveyDetailUseCase.call(GetSurveyDetailInput(
      surveyId: surveyUiModel.id,
    ));
    if (result is Success<SurveyDetail>) {
      final surveyDetail = result.value;
      _surveySubject.add(SurveyUiModel.fromSurveyDetail(surveyUiModel, surveyDetail));
      state = const SurveyDetailState.success();
    } else {
      _handleError(result as Failed);
    }
  }

  _handleError(Failed result) {
    state = SurveyDetailState.error(result.getErrorMessage());
  }

  @override
  void dispose() async {
    await _surveySubject.close();
    super.dispose();
  }
}
