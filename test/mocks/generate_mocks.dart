import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_survey/api/authentication_service.dart';
import 'package:flutter_survey/api/repository/authentication_repository.dart';
import 'package:flutter_survey/api/repository/survey_repository.dart';
import 'package:flutter_survey/api/survey_service.dart';
import 'package:flutter_survey/local/local_storage.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/get_surveys_use_case.dart';
import 'package:flutter_survey/usecases/is_logged_in_use_case.dart';
import 'package:flutter_survey/usecases/login_use_case.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  DioException,
  AuthenticationService,
  SurveyService,
  LocalStorage,
  FlutterSecureStorage,
  AuthenticationRepository,
  SurveyRepository,
  IsLoggedInUseCase,
  LoginUseCase,
  GetSurveysUseCase,
  UseCaseException
])
main() {
  // empty class to generate mock repository classes
}
