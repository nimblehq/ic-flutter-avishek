import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_survey/local/local_storage.dart';

const String _authorizationHeader = "Authorization";
const String _tokenType = "Bearer";

class AppInterceptor extends Interceptor {
  final bool _requireAuthenticate;
  final LocalStorage _localStorage;
  final Dio _dio;

  AppInterceptor(
    this._requireAuthenticate,
    this._localStorage,
    this._dio,
  );

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_requireAuthenticate) {
      final accessToken = await _localStorage.getAccessToken();
      final header = "$_tokenType $accessToken";
      options.headers.putIfAbsent(_authorizationHeader, () => header);
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    if ((statusCode == HttpStatus.forbidden ||
            statusCode == HttpStatus.unauthorized) &&
        _requireAuthenticate) {
      _doRefreshToken(err, handler);
    } else {
      handler.next(err);
    }
  }

  Future<void> _doRefreshToken(
      DioException ex, ErrorInterceptorHandler handler) async {
    try {
      // TODO Request new token

      // if (result is Success) {
      // TODO Update new token header
      // err.requestOptions.headers[_headerAuthorization] = newToken;

      // Create request with new access token
      final options = Options(
          method: ex.requestOptions.method, headers: ex.requestOptions.headers);
      final newRequest = await _dio.request(
          "${ex.requestOptions.baseUrl}${ex.requestOptions.path}",
          options: options,
          data: ex.requestOptions.data,
          queryParameters: ex.requestOptions.queryParameters);
      handler.resolve(newRequest);
      //  } else {
      //    handler.next(err);
      //  }
    } catch (exception) {
      if (exception is DioException) {
        handler.next(exception);
      } else {
        handler.next(ex);
      }
    }
  }
}
