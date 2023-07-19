import 'package:flutter_survey/api/api_service.dart';
import 'package:flutter_survey/api/exception/network_exceptions.dart';
import 'package:flutter_survey/model/response/user_response.dart';
import 'package:injectable/injectable.dart';

abstract class CredentialRepository {
  Future<List<UserResponse>> getUsers();
}

@LazySingleton(as: CredentialRepository)
class CredentialRepositoryImpl extends CredentialRepository {
  final ApiService _apiService;

  CredentialRepositoryImpl(this._apiService);

  @override
  Future<List<UserResponse>> getUsers() async {
    try {
      return await _apiService.getUsers();
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }
}
