import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const String keyAccessToken = 'KEY_TOKEN';
const String keyRefreshToken = 'KEY_REFRESH_TOKEN';

abstract class LocalStorage {
  Future<String> getAccessToken();

  Future<void> saveAccessToken(String token);

  Future<String> getRefreshToken();

  Future<void> saveRefreshToken(String refreshToken);

  Future<void> clear();

  Future<bool> get isLoggedIn;
}

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  late final FlutterSecureStorage _secureStorage;

  LocalStorageImpl(this._secureStorage);

  @override
  Future<String> getAccessToken() async {
    final accessToken = await _secureStorage.read(key: keyAccessToken);
    return accessToken ?? "";
  }

  @override
  Future<bool> saveAccessToken(String accessToken) async {
    try {
      await _secureStorage.write(key: keyAccessToken, value: accessToken);
    } catch (exception) {
      return false;
    }
    return true;
  }

  @override
  Future<String> getRefreshToken() async {
    final refreshToken = await _secureStorage.read(key: keyRefreshToken);
    return refreshToken ?? "";
  }

  @override
  Future<bool> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(
        key: keyRefreshToken,
        value: refreshToken,
      );
    } catch (exception) {
      return false;
    }
    return true;
  }

  @override
  Future<void> clear() {
    return _secureStorage.deleteAll();
  }

  @override
  Future<bool> get isLoggedIn {
    return _secureStorage.containsKey(key: keyAccessToken);
  }
}
