import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class LocalModule {
  @singleton
  @preResolve
  Future<FlutterSecureStorage> get secureStorage async =>
      const FlutterSecureStorage();
}
