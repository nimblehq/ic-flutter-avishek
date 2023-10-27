import 'package:dio/dio.dart';
import 'package:flutter_survey/model/request/refresh_token_request.dart';
import 'package:retrofit/http.dart';

import '../model/request/auth_token_request.dart';
import '../model/response/auth_token_response.dart';

part 'authentication_service.g.dart';

abstract class BaseAuthenticationService {
  Future<AuthTokenResponse> logIn(
    @Body() AuthTokenRequest body,
  );

  Future<AuthTokenResponse> refreshToken(
    @Body() RefreshTokenRequest body,
  );
}

@RestApi()
abstract class AuthenticationService extends BaseAuthenticationService {
  factory AuthenticationService(Dio dio, {String baseUrl}) =
      _AuthenticationService;

  @override
  @POST('api/v1/oauth/token')
  Future<AuthTokenResponse> logIn(
    @Body() AuthTokenRequest body,
  );

  @override
  @POST('api/v1/oauth/token')
  Future<AuthTokenResponse> refreshToken(
    @Body() RefreshTokenRequest body,
  );
}
