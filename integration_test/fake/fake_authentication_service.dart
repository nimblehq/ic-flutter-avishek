import 'package:flutter_survey/api/authentication_service.dart';
import 'package:flutter_survey/model/request/auth_token_request.dart';
import 'package:flutter_survey/model/response/auth_token_response.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_data.dart';

const String loginKey = 'login';

class FakeAuthenticationService extends Fake
    implements BaseAuthenticationService {
  @override
  Future<AuthTokenResponse> logIn(AuthTokenRequest body) async {
    final response = FakeData.fakeResponses[loginKey]!;

    if (response.statusCode != 200) {
      throw fakeDioException(response.statusCode);
    }
    return AuthTokenResponse.fromJson(response.json);
  }
}
