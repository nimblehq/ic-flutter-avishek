import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefKeyAccessToken = 'PREF_KEY_TOKEN';
const String _prefKeyRefreshToken = 'PREF_KEY_REFRESH_TOKEN';

abstract class LocalStorage {
  Future<String> getAccessToken();

  Future<void> saveAccessToken(String token);

  Future<String> getRefreshToken();

  Future<void> saveRefreshToken(String refreshToken);

  Future<void> clear();

  bool get isLoggedIn;
}

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  late SharedPreferences _prefs;

  LocalStorageImpl(this._prefs);

  @override
  Future<String> getAccessToken() async {
    return _prefs.getString(_prefKeyAccessToken) ?? "";
  }

  @override
  Future<bool> saveAccessToken(String token) async {
    return await _prefs.setString(_prefKeyAccessToken, token);
  }

  @override
  Future<String> getRefreshToken() async {
    return _prefs.getString(_prefKeyRefreshToken) ?? "";
  }

  @override
  Future<bool> saveRefreshToken(String refreshToken) async {
    return await _prefs.setString(_prefKeyRefreshToken, refreshToken);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  bool get isLoggedIn {
    return _prefs.containsKey(_prefKeyAccessToken);
  }
}
