import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/ui/login/login_screen.dart';
import 'package:flutter_survey/ui/login/login_state.dart';
import 'package:flutter_survey/ui/login/login_view_model.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('LoginViewModelTest', () {
    late MockIsLoggedInUseCase mockIsLoggedInUseCase;
    late MockLoginUseCase mockLoginUseCase;
    late ProviderContainer container;

    setUp(() {
      mockIsLoggedInUseCase = MockIsLoggedInUseCase();
      mockLoginUseCase = MockLoginUseCase();
      container = ProviderContainer(
        overrides: [
          loginViewModelProvider.overrideWithValue(
              LoginViewModel(mockIsLoggedInUseCase, mockLoginUseCase)),
        ],
      );
      addTearDown(container.dispose);
    });

    test('When initializing, it initializes with Init', () {
      expect(container.read(loginViewModelProvider), const LoginState.init());
    });

    test(
        'When checking for logged in status and user is logged in, it emits values accordingly',
        () {
      when(mockIsLoggedInUseCase.call()).thenAnswer((_) async => Success(true));
      final stateStream =
          container.read(loginViewModelProvider.notifier).stream;

      expect(stateStream, emitsInOrder([const LoginState.success()]));
      container.read(loginViewModelProvider.notifier).checkIfLoggedIn();
    });

    test(
        'When checking for logged in status and user is NOT logged in, it emits values accordingly',
        () {
      when(mockIsLoggedInUseCase.call())
          .thenAnswer((_) async => Success(false));
      final stateStream =
          container.read(loginViewModelProvider.notifier).stream;

      expect(stateStream, emitsInOrder([const LoginState.loggedOut()]));
      container.read(loginViewModelProvider.notifier).checkIfLoggedIn();
    });

    test(
      'When checking for logged in status runs into an error, it emits values accordingly',
      () {
        const mockErrorMessage = "errorMessage";
        when(mockIsLoggedInUseCase.call()).thenAnswer(
            (_) async => Failed(UseCaseException(Exception(mockErrorMessage))));
        final stateStream =
            container.read(loginViewModelProvider.notifier).stream;

        expect(
          stateStream,
          emitsInOrder([const LoginState.error(mockErrorMessage)]),
        );
        container.read(loginViewModelProvider.notifier).checkIfLoggedIn();
      },
    );

    test('When logging in successfully, it returns Success', () {
      when(mockLoginUseCase.call(any)).thenAnswer((_) async => Success(null));
      final stateStream =
          container.read(loginViewModelProvider.notifier).stream;
      expect(
          stateStream,
          emitsInOrder(
              [const LoginState.loading(), const LoginState.success()]));
      container
          .read(loginViewModelProvider.notifier)
          .logIn('email', 'password');
    });

    test('When logging in unsuccessfully, it returns Failed', () {
      final mockException = MockUseCaseException();
      const expectedNetworkExceptions = NetworkExceptions.defaultError("error");
      when(mockException.actualException).thenReturn(expectedNetworkExceptions);
      when(mockLoginUseCase.call(any))
          .thenAnswer((_) async => Failed(mockException));
      final stateStream =
          container.read(loginViewModelProvider.notifier).stream;
      expect(
          stateStream,
          emitsInOrder([
            const LoginState.loading(),
            LoginState.error(
              NetworkExceptions.getErrorMessage(expectedNetworkExceptions),
            )
          ]));
      container
          .read(loginViewModelProvider.notifier)
          .logIn('email', 'password');
    });

    test('When entering a null value for email, it returns false', () {
      expect(
        container.read(loginViewModelProvider.notifier).isValidEmail(null),
        false,
      );
    });

    test('When entering an invalid email, it returns false', () {
      expect(
        container.read(loginViewModelProvider.notifier).isValidEmail("email"),
        false,
      );
    });

    test('When entering a valid email, it returns true', () {
      expect(
        container
            .read(loginViewModelProvider.notifier)
            .isValidEmail("email@example.com"),
        true,
      );
    });

    test('When entering an invalid password, it returns false', () {
      expect(
        container
            .read(loginViewModelProvider.notifier)
            .isValidPassword("12345"),
        false,
      );
    });

    test('When entering a valid password, it returns true', () {
      expect(
        container
            .read(loginViewModelProvider.notifier)
            .isValidPassword("123456"),
        true,
      );
    });
  });
}
