import 'package:flutter_survey/api/authentication_service.dart';
import 'package:flutter_survey/model/response/auth_token_response.dart';
import 'package:injectable/injectable.dart';

import '../../model/auth_token.dart';
import '../../model/request/auth_token_request.dart';
import '../exception/network_exceptions.dart';

abstract class AuthenticationRepository {
  Future<AuthToken> logIn({
    required String email,
    required String password,
  });
}

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationService _authenticationService;

  AuthenticationRepositoryImpl(this._authenticationService);

  @override
  Future<AuthToken> logIn(
      {required String email, required String password}) async {
    try {
      final response = await _authenticationService.logIn(
        AuthTokenRequest(email: email, password: password),
      );
      return response.toAuthToken();
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }
}
