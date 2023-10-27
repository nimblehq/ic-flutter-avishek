import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/model/auth_token.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/refresh_token_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('RefreshTokenUseCaseTest', () {
    late MockAuthenticationRepository mockAuthenticationRepository;
    late MockLocalStorage mockLocalStorage;
    late RefreshTokenUseCase useCase;

    setUp(() {
      mockAuthenticationRepository = MockAuthenticationRepository();
      mockLocalStorage = MockLocalStorage();

      when(mockLocalStorage.getRefreshToken())
          .thenAnswer((_) async => "refreshToken");

      useCase = RefreshTokenUseCase(mockAuthenticationRepository, mockLocalStorage);
    });

    test('When calling refresh token successfully, it returns Success result',
        () async {
      when(mockAuthenticationRepository.refreshToken(refreshToken: anyNamed('refreshToken')))
          .thenAnswer((_) async => const AuthToken(
                accessToken: "accessToken",
                tokenType: "tokenType",
                expiresIn: 111,
                refreshToken: "refreshToken",
              ));
      final result = await useCase.call();

      expect(result, isA<Success>());
      verify(mockLocalStorage.saveAccessToken("accessToken")).called(1);
      verify(mockLocalStorage.saveRefreshToken("refreshToken")).called(1);
    });

    test('When calling refresh token failed, it returns Failed result',
        () async {
      when(mockAuthenticationRepository.refreshToken(refreshToken: anyNamed('refreshToken')))
          .thenAnswer((_) => Future.error(
                const NetworkExceptions.unauthorisedRequest(),
              ));
      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException,
          const NetworkExceptions.unauthorisedRequest());
    });
  });
}
