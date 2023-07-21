import 'package:flutter_survey/api/authentication_service.dart';
import 'package:flutter_survey/di/provider/dio_provider.dart';
import 'package:injectable/injectable.dart';

import '../../api/survey_service.dart';
import '../../env.dart';

@module
abstract class NetworkModule {
  @LazySingleton()
  AuthenticationService provideAuthenticationService(DioProvider dioProvider) {
    return AuthenticationService(
      dioProvider.getUnAuthenticatedDio(),
      baseUrl: Env.restApiEndpoint,
    );
  }

  @LazySingleton()
  SurveyService provideSurveyService(DioProvider dioProvider) {
    return SurveyService(
      dioProvider.getAuthenticatedDio(),
      baseUrl: Env.restApiEndpoint,
    );
  }
}
