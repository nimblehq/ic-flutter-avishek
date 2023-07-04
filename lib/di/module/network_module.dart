import 'package:flutter_survey/api/api_service.dart';
import 'package:flutter_survey/di/provider/dio_provider.dart';
import 'package:injectable/injectable.dart';

import '../../env.dart';

@module
abstract class NetworkModule {
  @LazySingleton()
  ApiService provideApiService(DioProvider dioProvider) {
    return ApiService(dioProvider.getDio(), baseUrl: Env.restApiEndpoint);
  }
}
