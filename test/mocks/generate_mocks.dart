import 'package:dio/dio.dart';
import 'package:flutter_survey/api/api_service.dart';
import 'package:flutter_survey/api/authentication_service.dart';
import 'package:flutter_survey/api/repository/authentication_repository.dart';
import 'package:flutter_survey/local/local_storage.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/login_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  DioException,
  ApiService,
  AuthenticationService,
  LocalStorage,
  SharedPreferences,
  AuthenticationRepository,
  LoginUseCase,
  UseCaseException
])
main() {
  // empty class to generate mock repository classes
}
