import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_survey/di/interceptor/app_interceptor.dart';
import 'package:flutter_survey/local/local_storage.dart';
import 'package:injectable/injectable.dart';

const String headerContentType = 'Content-Type';
const String defaultContentType = 'application/json; charset=utf-8';

@LazySingleton()
class DioProvider {
  Dio? _unauthenticatedDio;
  Dio? _authenticatedDio;
  final LocalStorage _localStorage;

  DioProvider(this._localStorage);

  Dio getUnauthenticatedDio() {
    _unauthenticatedDio ??= _createDio();
    return _unauthenticatedDio!;
  }

  Dio getAuthenticatedDio() {
    _authenticatedDio ??= _createDio(requireAuthenticate: true);
    return _authenticatedDio!;
  }

  Dio _createDio({bool requireAuthenticate = false}) {
    final dio = Dio();
    final appInterceptor = AppInterceptor(
      requireAuthenticate,
      _localStorage,
      dio,
    );
    final interceptors = <Interceptor>[];
    interceptors.add(appInterceptor);
    if (!kReleaseMode) {
      interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    }

    return dio
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 50)
      ..options.headers = {headerContentType: defaultContentType}
      ..interceptors.addAll(interceptors);
  }
}
