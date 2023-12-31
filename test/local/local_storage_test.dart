import 'package:flutter_survey/local/local_storage.dart';
import 'package:flutter_survey/model/survey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group("LocalStorage", () {
    MockFlutterSecureStorage mockFlutterSecureStorage =
        MockFlutterSecureStorage();
    MockBox mockSurveyBox = MockBox();
    late LocalStorage localStorage;

    setUp(() {
      localStorage = LocalStorageImpl(mockFlutterSecureStorage, mockSurveyBox);
    });

    test(
      "When there's access token in the local storage, it returns the access token",
      () async {
        var expectedAccessToken = "access_token";
        when(mockFlutterSecureStorage.read(key: keyAccessToken))
            .thenAnswer((_) async => expectedAccessToken);

        final accessToken = await localStorage.getAccessToken();

        expect(accessToken, expectedAccessToken);
      },
    );

    test(
      "When there's NO access token in the local storage, it returns an empty string",
      () async {
        var expectedAccessToken = "";
        when(mockFlutterSecureStorage.read(key: keyAccessToken))
            .thenAnswer((_) async => null);

        final accessToken = await localStorage.getAccessToken();

        expect(accessToken, expectedAccessToken);
      },
    );

    test(
      "When saving access token in the local storage, it calls the method accordingly",
      () {
        var expectedAccessToken = "access_token";
        when(mockFlutterSecureStorage.write(
          key: anyNamed("key"),
          value: anyNamed("value"),
        )).thenAnswer((_) async => true);

        localStorage.saveAccessToken(expectedAccessToken);

        verify(mockFlutterSecureStorage.write(
          key: keyAccessToken,
          value: expectedAccessToken,
        )).called(1);
      },
    );

    test(
      "When there's refresh token in the local storage, it returns the refresh token",
      () async {
        var expectedRefreshToken = "refresh_token";
        when(mockFlutterSecureStorage.read(key: keyRefreshToken))
            .thenAnswer((_) async => expectedRefreshToken);

        final accessToken = await localStorage.getRefreshToken();

        expect(accessToken, expectedRefreshToken);
      },
    );

    test(
      "When there's NO refresh token in the local storage, it returns an empty string",
      () async {
        var expectedRefreshToken = "";
        when(mockFlutterSecureStorage.read(key: keyRefreshToken))
            .thenAnswer((_) async => null);

        final accessToken = await localStorage.getRefreshToken();

        expect(accessToken, expectedRefreshToken);
      },
    );

    test(
      "When saving refresh token in the local storage, it calls the method accordingly",
      () {
        var expectedRefreshToken = "refresh_token";
        when(mockFlutterSecureStorage.write(
          key: anyNamed("key"),
          value: anyNamed("value"),
        )).thenAnswer((_) async => true);

        localStorage.saveRefreshToken(expectedRefreshToken);

        verify(mockFlutterSecureStorage.write(
          key: keyRefreshToken,
          value: expectedRefreshToken,
        )).called(1);
      },
    );

    test(
      "When clearing the local storage, it calls the method accordingly",
      () {
        when(mockFlutterSecureStorage.deleteAll())
            .thenAnswer((_) async => true);

        localStorage.clear();

        verify(mockFlutterSecureStorage.deleteAll()).called(1);
      },
    );

    test(
      "When checking logged in status, it returns the value accordingly",
      () async {
        var expectedValue = true;
        when(mockFlutterSecureStorage.containsKey(key: anyNamed("key")))
            .thenAnswer((_) async => expectedValue);

        final isLoggedIn = await localStorage.isLoggedIn;

        expect(isLoggedIn, expectedValue);
      },
    );

    test(
      "When there are cached surveys, it returns the value accordingly",
      () async {
        final expectedValue = [];
        when(mockSurveyBox.get(any, defaultValue: anyNamed("defaultValue")))
            .thenAnswer((_) => expectedValue);

        final cachedSurveys = await localStorage.surveys;

        expect(cachedSurveys, expectedValue);
      },
    );

    test(
      "When caching surveys successfully, it calls the methods accordingly",
      () async {
        final surveys = [
          const Survey(
            id: "1",
            title: "title",
            description: "description",
            coverImageUrl: "coverImageUrl",
          )
        ];
        when(mockSurveyBox.get(any, defaultValue: anyNamed("defaultValue")))
            .thenAnswer((_) => surveys);

        await localStorage.cacheSurveys(surveys);

        verify(mockSurveyBox.put(any, any)).called(1);
      },
    );

    test(
      "When clearing cached surveys, it calls the methods accordingly",
      () async {
        await localStorage.clearCachedSurveys();

        verify(mockSurveyBox.delete(any)).called(1);
      },
    );
  });
}
