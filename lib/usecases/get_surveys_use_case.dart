import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:injectable/injectable.dart';

import '../api/repository/survey_repository.dart';
import '../model/survey.dart';
import 'base/base_use_case.dart';

class GetSurveysInput {
  final int pageNumber;
  final int pageSize;

  GetSurveysInput({
    required this.pageNumber,
    required this.pageSize,
  });
}

@lazySingleton
class GetSurveysUseCase extends UseCase<List<Survey>, GetSurveysInput> {
  final SurveyRepository _surveyRepository;

  const GetSurveysUseCase(this._surveyRepository);

  @override
  Future<Result<List<Survey>>> call(GetSurveysInput params) {
    return _surveyRepository
        .getSurveys(params.pageNumber, params.pageSize)
        .then((value) =>
            Success(value) as Result<List<Survey>>) // ignore: unnecessary_cast
        .onError<NetworkExceptions>(
            (err, stackTrace) => Failed(UseCaseException(err)));
  }
}
