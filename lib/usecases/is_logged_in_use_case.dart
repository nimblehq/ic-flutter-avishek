import 'package:injectable/injectable.dart';

import '../local/local_storage.dart';
import 'base/base_use_case.dart';

@lazySingleton
class IsLoggedInUseCase extends NoParamsUseCase<bool> {
  final LocalStorage _localStorage;

  const IsLoggedInUseCase(this._localStorage);

  @override
  Future<Result<bool>> call() {
    return _localStorage.isLoggedIn
        .then((isLoggedIn) =>
            Success(isLoggedIn) as Result<bool>) // ignore: unnecessary_cast
        .onError<Exception>((err, stackTrace) => Failed(UseCaseException(err)));
  }
}
