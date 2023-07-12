import 'package:injectable/injectable.dart';

import '../api/exception/network_exceptions.dart';
import '../api/repository/authentication_repository.dart';
import 'base/base_use_case.dart';

class LoginInput {
  final String email;
  final String password;

  LoginInput({required this.email, required this.password});
}

@Injectable()
class LoginUseCase extends UseCase<void, LoginInput> {
  final AuthenticationRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Result<void>> call(LoginInput input) {
    return _repository
        .logIn(email: input.email, password: input.password)
        .then((_) => Success(null) as Result<dynamic>)
        .onError<NetworkExceptions>(
            (err, stackTrace) => Failed(UseCaseException(err)));
  }
}
