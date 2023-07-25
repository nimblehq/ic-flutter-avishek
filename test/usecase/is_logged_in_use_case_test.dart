import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_survey/usecases/is_logged_in_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group("IsLoggedInUseCase", () {
    final MockLocalStorage mockLocalStorage = MockLocalStorage();

    late IsLoggedInUseCase isLoggedInUseCase;

    setUp(() => {isLoggedInUseCase = IsLoggedInUseCase(mockLocalStorage)});

    test("When calling the use case and user is logged in, it returns true",
        () async {
      var expectedResult = true;
      when(
        mockLocalStorage.isLoggedIn,
      ).thenAnswer((_) async => expectedResult);

      final result = await isLoggedInUseCase.call();

      expect((result as Success).value, expectedResult);
    });

    test(
        "When calling the use case and user is NOT logged in, it returns false",
        () async {
      var expectedResult = false;
      when(
        mockLocalStorage.isLoggedIn,
      ).thenAnswer((_) async => expectedResult);

      final result = await isLoggedInUseCase.call();

      expect((result as Success).value, expectedResult);
    });

    test("When calling the use case unsuccessfully, it returns Failed",
        () async {
      when(
        mockLocalStorage.isLoggedIn,
      ).thenAnswer((_) => Future.error(Exception()));

      final result = await isLoggedInUseCase.call();

      expect(result, isA<Failed>());
    });
  });
}
