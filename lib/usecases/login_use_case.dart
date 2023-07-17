import 'package:injectable/injectable.dart';

import '../api/exception/network_exceptions.dart';
import '../api/repository/authentication_repository.dart';
import '../local/local_storage.dart';
import '../model/auth_token.dart';
import 'base/base_use_case.dart';

class LoginInput {
  final String email;
  final String password;

  LoginInput({required this.email, required this.password});
}

@lazySingleton
class LoginUseCase extends UseCase<void, LoginInput> {
  final AuthenticationRepository _repository;
  final LocalStorage _localStorage;

  const LoginUseCase(this._repository, this._localStorage);

  @override
  Future<Result<void>> call(LoginInput params) {
    return _repository
        .logIn(email: params.email, password: params.password)
        .then((token) => saveTokens(token))
        .onError<NetworkExceptions>(
            (err, stackTrace) => Failed(UseCaseException(err)));
  }

  Result<void> saveTokens(AuthToken authToken) {
    _localStorage.saveAccessToken(authToken.accessToken);
    _localStorage.saveRefreshToken(authToken.refreshToken);
    return Success(null);
  }
}
