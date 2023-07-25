import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/usecases/is_logged_in_use_case.dart';

import '../../usecases/base/base_use_case.dart';
import '../../usecases/login_use_case.dart';
import 'login_state.dart';

const _minPasswordLength = 6;

class LoginViewModel extends StateNotifier<LoginState> {
  final IsLoggedInUseCase _isLoggedInUseCase;
  final LoginUseCase _loginUseCase;

  LoginViewModel(
    this._isLoggedInUseCase,
    this._loginUseCase,
  ) : super(const LoginState.init());

  void checkIfLoggedIn() async {
    final result = await _isLoggedInUseCase.call();
    if (result is Success<bool>) {
      var isLoggedIn = result.value;
      state = isLoggedIn
          ? const LoginState.success()
          : const LoginState.loggedOut();
    } else {
      _handleError(result as Failed);
    }
  }

  Future<void> logIn(String email, String password) async {
    state = const LoginState.loading();
    Result<void> result =
        await _loginUseCase.call(LoginInput(email: email, password: password));
    if (result is Success) {
      state = const LoginState.success();
    } else {
      _handleError(result as Failed);
    }
  }

  _handleError(Failed result) {
    state = LoginState.error(result.getErrorMessage());
  }

  bool isValidEmail(String? email) {
    return email != null && EmailValidator.validate(email);
  }

  bool isValidPassword(String? email) {
    return email != null && email.length >= _minPasswordLength;
  }
}
