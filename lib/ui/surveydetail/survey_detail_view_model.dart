import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_state.dart';
import 'package:rxdart/subjects.dart';

import '../../model/answer.dart';
import '../../model/request/submit_survey_request.dart';
import '../../model/survey_detail.dart';
import '../../usecases/base/base_use_case.dart';
import '../../usecases/get_survey_detail_use_case.dart';
import '../../usecases/submit_survey_use_case.dart';
import '../home/survey_ui_model.dart';
import 'multi_choice_form.dart';

class SurveyDetailViewModel extends StateNotifier<SurveyDetailState> {
  final GetSurveyDetailUseCase _getSurveyDetailUseCase;
  final SubmitSurveyUseCase _submitSurveyUseCase;

  SurveyDetailViewModel(
    this._getSurveyDetailUseCase,
    this._submitSurveyUseCase,
  ) : super(const SurveyDetailState.init());

  final BehaviorSubject<SurveyUiModel> _surveySubject = BehaviorSubject();

  Stream<SurveyUiModel> get surveyStream => _surveySubject.stream;

  final List<SubmitQuestion> _submitQuestions = [];

  Future<void> loadSurveyDetail(SurveyUiModel surveyUiModel) async {
    _surveySubject.add(surveyUiModel);
    state = const SurveyDetailState.success();

    state = const SurveyDetailState.loading();
    final result = await _getSurveyDetailUseCase.call(GetSurveyDetailInput(
      surveyId: surveyUiModel.id,
    ));
    if (result is Success<SurveyDetail>) {
      final surveyDetail = result.value;
      _surveySubject
          .add(SurveyUiModel.fromSurveyDetail(surveyUiModel, surveyDetail));
      state = const SurveyDetailState.success();
    } else {
      _handleError(result as Failed);
    }
  }

  _handleError(Failed result) {
    state = SurveyDetailState.error(result.getErrorMessage());
  }

  void saveDropdownAnswer(String questionId, Answer answer) {
    _saveAnswersToQuestions(questionId, [SubmitAnswer.fromAnswer(answer)]);
  }

  List<Answer>? _getAnswers(String questionId) {
    return _surveySubject.value.questions
        .firstWhereOrNull((element) => element.id == questionId)
        ?.answers;
  }

  void saveRating(String questionId, int rating) {
    final answers = _getAnswers(questionId);
    final selectedAnswer = answers
        ?.firstWhereOrNull((element) => element.displayOrder == rating - 1);

    final submitAnswers = selectedAnswer != null
        ? [SubmitAnswer.fromAnswer(selectedAnswer)]
        : <SubmitAnswer>[];

    _saveAnswersToQuestions(questionId, submitAnswers);
  }

  void saveMultiChoiceItems(
    String questionId,
    List<MultiChoiceItem> items,
  ) {
    _saveAnswersToQuestions(questionId,
        items.map((e) => SubmitAnswer(id: e.id, answer: e.label)).toList());
  }

  void saveText(String questionId, String text) {
    final answers = _getAnswers(questionId);
    if (answers == null || answers.isEmpty) return;

    final submitAnswers = text.isNotEmpty
        ? [SubmitAnswer(id: answers.first.id, answer: text)]
        : <SubmitAnswer>[];
    _saveAnswersToQuestions(questionId, submitAnswers);
  }

  void saveTextFieldsAnswer(String questionId, String answerId, String text) {
    final submitQuestion = _submitQuestions
        .firstWhereOrNull((element) => element.id == questionId);
    final submitAnswer = submitQuestion?.answers
        .firstWhereOrNull((element) => element.id == answerId);

    // Clear answers
    if (text.isEmpty && submitQuestion != null && submitAnswer != null) {
      submitQuestion.answers.removeWhere((element) => element.id == answerId);
      return;
    }

    final newSubmitAnswer = SubmitAnswer(id: answerId, answer: text);
    if (submitQuestion == null) {
      _submitQuestions
          .add(SubmitQuestion(id: questionId, answers: [newSubmitAnswer]));
      return;
    }

    if (submitAnswer == null) {
      submitQuestion.answers.add(newSubmitAnswer);
      return;
    }

    submitAnswer.answer = text;
  }

  void _saveAnswersToQuestions(String questionId, List<SubmitAnswer> answers) {
    final question = _submitQuestions
        .firstWhereOrNull((element) => element.id == questionId);

    if (question == null) {
      _submitQuestions.add(SubmitQuestion(
        id: questionId,
        answers: answers,
      ));
    } else {
      question.answers.clear();
      question.answers.addAll(answers);
    }
  }

  Future<void> submitSurvey() async {
    state = const SurveyDetailState.loading();
    final result = await _submitSurveyUseCase.call(
      SubmitSurveyInput(
        surveyId: _surveySubject.value.id,
        questions: _submitQuestions,
      ),
    );
    if (result is Success<void>) {
      state = const SurveyDetailState.submitted();
    } else {
      _handleError(result as Failed);
    }
  }

  @override
  void dispose() async {
    await _surveySubject.close();
    super.dispose();
  }
}
