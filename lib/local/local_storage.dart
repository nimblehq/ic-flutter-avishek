import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const String _keyAccessToken = 'KEY_TOKEN';
const String _keyRefreshToken = 'KEY_REFRESH_TOKEN';

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
    final accessToken = await _secureStorage.read(key: _keyAccessToken);
    return accessToken ?? "";
  }

  @override
  Future<bool> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(key: _keyAccessToken, value: token);
    } catch (exception) {
      return false;
    }
    return true;
  }

  @override
  Future<String> getRefreshToken() async {
    final refreshToken = await _secureStorage.read(key: _keyRefreshToken);
    return refreshToken ?? "";
  }

  @override
  Future<bool> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(
        key: _keyRefreshToken,
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
    return _secureStorage.containsKey(key: _keyAccessToken);
  }
}
