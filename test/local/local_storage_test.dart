import 'package:flutter_survey/local/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group("LocalStorage", () {
    MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
    late LocalStorage localStorage;

    setUp(() {
      localStorage = LocalStorageImpl(mockSharedPreferences);
    });

    test(
      "When there's access token in the local storage, it returns the access token",
      () async {
        var expectedAccessToken = "access_token";
        when(mockSharedPreferences.getString(prefKeyAccessToken))
            .thenAnswer((_) => expectedAccessToken);

        final accessToken = await localStorage.getAccessToken();

        expect(accessToken, expectedAccessToken);
      },
    );

    test(
      "When there's NO access token in the local storage, it returns an empty string",
      () async {
        var expectedAccessToken = "";
        when(mockSharedPreferences.getString(prefKeyAccessToken))
            .thenAnswer((_) => null);

        final accessToken = await localStorage.getAccessToken();

        expect(accessToken, expectedAccessToken);
      },
    );

    test(
      "When saving access token in the local storage, it calls the method accordingly",
      () {
        var expectedAccessToken = "access_token";
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        localStorage.saveAccessToken(expectedAccessToken);

        verify(mockSharedPreferences.setString(
          prefKeyAccessToken,
          expectedAccessToken,
        )).called(1);
      },
    );

    test(
      "When there's refresh token in the local storage, it returns the refresh token",
      () async {
        var expectedRefreshToken = "refresh_token";
        when(mockSharedPreferences.getString(prefKeyRefreshToken))
            .thenAnswer((_) => expectedRefreshToken);

        final accessToken = await localStorage.getRefreshToken();

        expect(accessToken, expectedRefreshToken);
      },
    );

    test(
      "When there's NO refresh token in the local storage, it returns an empty string",
      () async {
        var expectedRefreshToken = "";
        when(mockSharedPreferences.getString(prefKeyRefreshToken))
            .thenAnswer((_) => null);

        final accessToken = await localStorage.getRefreshToken();

        expect(accessToken, expectedRefreshToken);
      },
    );

    test(
      "When saving refresh token in the local storage, it calls the method accordingly",
      () {
        var expectedRefreshToken = "refresh_token";
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        localStorage.saveRefreshToken(expectedRefreshToken);

        verify(mockSharedPreferences.setString(
          prefKeyRefreshToken,
          expectedRefreshToken,
        )).called(1);
      },
    );

    test(
      "When clearing the local storage, it calls the method accordingly",
      () {
        when(mockSharedPreferences.clear()).thenAnswer((_) async => true);

        localStorage.clear();

        verify(mockSharedPreferences.clear()).called(1);
      },
    );

    test(
      "When checking logged in status, it returns the value accordingly",
      () {
        var expectedValue = true;
        when(mockSharedPreferences.containsKey(any))
            .thenAnswer((_) => expectedValue);

        expect(localStorage.isLoggedIn, expectedValue);
      },
    );
  });
}
