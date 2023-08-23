import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/api/repository/survey_repository.dart';
import 'package:injectable/injectable.dart';

import '../model/request/submit_survey_request.dart';
import 'base/base_use_case.dart';

class SubmitSurveyInput {
  String surveyId;
  List<SubmitQuestion> questions;

  SubmitSurveyInput({
    required this.surveyId,
    required this.questions,
  });
}

@lazySingleton
class SubmitSurveyUseCase extends UseCase<void, SubmitSurveyInput> {
  final SurveyRepository _surveyRepository;

  const SubmitSurveyUseCase(this._surveyRepository);

  @override
  Future<Result<void>> call(SubmitSurveyInput params) {
    return _surveyRepository
        .submitSurvey(params.surveyId, params.questions)
        .then((value) =>
            Success(null) as Result<void>) // ignore: unnecessary_cast
        .onError<NetworkExceptions>(
            (err, stackTrace) => Failed(UseCaseException(err)));
  }
}
