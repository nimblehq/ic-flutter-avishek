import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../constants.dart';
import '../model/survey.dart';

const String keyAccessToken = 'KEY_TOKEN';
const String keyRefreshToken = 'KEY_REFRESH_TOKEN';
const String _surveysKey = 'surveys';

abstract class LocalStorage {
  Future<String> getAccessToken();

  Future<void> saveAccessToken(String token);

  Future<String> getRefreshToken();

  Future<void> saveRefreshToken(String refreshToken);

  Future<void> clear();

  Future<bool> get isLoggedIn;

  Future<List<Survey>> get surveys;

  Future<void> cacheSurveys(List<Survey> surveys);

  Future<void> clearCachedSurveys();
}

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  late final FlutterSecureStorage _secureStorage;
  late final Box _surveyBox;

  LocalStorageImpl(
      this._secureStorage, @Named(HiveConstants.surveyBox) this._surveyBox);

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

  @override
  Future<List<Survey>> get surveys async =>
      List<Survey>.from(_surveyBox.get(_surveysKey, defaultValue: []));

  @override
  Future<void> cacheSurveys(List<Survey> surveys) async {
    final currentSurveys = await this.surveys;
    currentSurveys.addAll(surveys);
    await _surveyBox.put(_surveysKey, currentSurveys);
  }

  @override
  Future<void> clearCachedSurveys() async {
    await _surveyBox.delete(_surveysKey);
  }
}
