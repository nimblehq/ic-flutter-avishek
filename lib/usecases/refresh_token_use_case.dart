import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/api/repository/authentication_repository.dart';
import 'package:flutter_survey/local/local_storage.dart';
import 'package:flutter_survey/model/auth_token.dart';
import 'package:flutter_survey/usecases/base/base_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class RefreshTokenUseCase extends NoParamsUseCase<void> {
  final AuthenticationRepository _authenticationRepository;
  final LocalStorage _localStorage;

  const RefreshTokenUseCase(
    this._authenticationRepository,
    this._localStorage,
  );

  @override
  Future<Result<void>> call() async {
    final refreshToken = await _localStorage.getRefreshToken();
    return _authenticationRepository
        .refreshToken(refreshToken: refreshToken)
        .then((value) => _saveTokens(value))
        .onError<NetworkExceptions>(
            (err, stackTrace) => Failed(UseCaseException(err)));
  }

  Result<void> _saveTokens(AuthToken data) {
    _localStorage.saveAccessToken(data.accessToken);
    _localStorage.saveRefreshToken(data.refreshToken);
    return Success(null);
  }
}
