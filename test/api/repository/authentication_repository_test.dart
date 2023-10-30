import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/api/repository/authentication_repository.dart';
import 'package:flutter_survey/model/auth_token.dart';
import 'package:flutter_survey/model/response/auth_token_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/generate_mocks.mocks.dart';

void main() {
  FlutterConfig.loadValueForTesting({
    'CLIENT_ID': 'CLIENT_ID',
    'CLIENT_SECRET': 'CLIENT_SECRET',
  });

  group("AuthenticationRepository", () {
    MockAuthenticationService mockAuthenticationService =
        MockAuthenticationService();
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository =
          AuthenticationRepositoryImpl(mockAuthenticationService);
    });

    test("When logging in successfully, it emits the corresponding value",
        () async {
      final authTokenResponse = AuthTokenResponse(
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        tokenType: 'tokenType',
        expiresIn: 0,
      );
      final expectedValue = authTokenResponse.toAuthToken();
      when(mockAuthenticationService.logIn(any))
          .thenAnswer((_) async => authTokenResponse);

      final result = await authenticationRepository.logIn(
        email: "email",
        password: "password",
      );

      expect(result, expectedValue);
    });

    test("When logging in fails, it emits the corresponding error", () async {
      when(mockAuthenticationService.logIn(any)).thenThrow(MockDioException());

      result() => authenticationRepository.logIn(
            email: "email",
            password: "password",
          );

      expect(result, throwsA(isA<NetworkExceptions>()));
    });

    test(
        'When calling refresh token successfully, it returns corresponding mapped result',
        () async {
      final authTokenResponse = AuthTokenResponse(
        tokenType: 'tokenType',
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        expiresIn: 0,
      );
      const expectedValue = AuthToken(
        tokenType: 'tokenType',
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        expiresIn: 0,
      );
      when(mockAuthenticationService.refreshToken(any))
          .thenAnswer((_) async => authTokenResponse);

      final result = await authenticationRepository.refreshToken(
          refreshToken: 'refreshToken');
      expect(result, expectedValue);
    });

    test(
        'When calling refresh token failed, it returns NetworkExceptions error',
        () async {
      when(mockAuthenticationService.refreshToken(any))
          .thenThrow(MockDioException());

      result() =>
          authenticationRepository.refreshToken(refreshToken: 'refreshToken');
      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });
}
