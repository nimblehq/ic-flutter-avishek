import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../usecases/base/base_use_case.dart';
import '../../usecases/login_use_case.dart';
import 'login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(const LoginState.init());

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
}
