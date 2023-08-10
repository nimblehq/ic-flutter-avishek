import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../api/repository/survey_repository.dart';
import '../model/survey.dart';
import 'base/base_use_case.dart';

class GetSurveysInput {
  final int pageNumber;
  final int pageSize;
  final bool shouldRefresh;

  GetSurveysInput({
    required this.pageNumber,
    required this.pageSize,
    this.shouldRefresh = false,
  });
}

@lazySingleton
class GetSurveysUseCase extends StreamUseCase<List<Survey>, GetSurveysInput> {
  final SurveyRepository _surveyRepository;

  const GetSurveysUseCase(this._surveyRepository);

  @override
  Stream<Result<List<Survey>>> call(GetSurveysInput params) {
    return _surveyRepository
        .getSurveys(
          params.pageNumber,
          params.pageSize,
          params.shouldRefresh,
        )
        .map((value) =>
            Success(value) as Result<List<Survey>>) // ignore: unnecessary_cast
        .onErrorReturnWith((err, stackTrace) => Failed(UseCaseException(err)));
  }
}
