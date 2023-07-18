import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/model/auth_token.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group("LoginUseCase", () {
    final MockAuthenticationRepository mockAuthenticationRepository =
        MockAuthenticationRepository();
    final MockLocalStorage mockLocalStorage = MockLocalStorage();

    late LoginUseCase loginUseCase;

    setUp(() => {
          loginUseCase =
              LoginUseCase(mockAuthenticationRepository, mockLocalStorage)
        });

    test("When calling the use case successfully, it returns Success",
        () async {
      const authToken = AuthToken(
          accessToken: "accessToken",
          refreshToken: "refreshToken",
          tokenType: "tokenType",
          expiresIn: 0);
      when(
        mockAuthenticationRepository.logIn(
          email: anyNamed("email"),
          password: anyNamed("password"),
        ),
      ).thenAnswer((_) async => authToken);
      when(mockLocalStorage.saveAccessToken(any)).thenAnswer((_) async => {});
      when(mockLocalStorage.saveRefreshToken(any)).thenAnswer((_) async => {});

      final result = await loginUseCase
          .call(LoginInput(email: "email", password: "password"));

      verify(mockLocalStorage.saveAccessToken(authToken.accessToken)).called(1);
      verify(mockLocalStorage.saveRefreshToken(authToken.refreshToken))
          .called(1);
      expect(result, isA<Success>());
    });

    test("When calling the use case unsuccessfully, it returns Failed",
        () async {
      when(
        mockAuthenticationRepository.logIn(
          email: anyNamed("email"),
          password: anyNamed("password"),
        ),
      ).thenAnswer((_) =>
          Future.error(NetworkExceptions.fromDioException(MockDioException())));

      final result = await loginUseCase
          .call(LoginInput(email: "email", password: "password"));

      expect(result, isA<Failed>());
    });
  });
}
