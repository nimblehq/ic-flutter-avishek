import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../constants.dart';

@module
abstract class StorageModule {
  @singleton
  @preResolve
  Future<FlutterSecureStorage> get secureStorage async =>
      const FlutterSecureStorage();

  @Named(HiveConstants.surveyBox)
  @singleton
  @preResolve
  Future<Box> get surveyBox => Hive.openBox(HiveConstants.surveyBox);
}
