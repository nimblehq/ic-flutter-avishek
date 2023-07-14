import 'package:json_annotation/json_annotation.dart';

import '../../api/response_converter.dart';
import '../auth_token.dart';

part 'auth_token_response.g.dart';

@JsonSerializable()
class AuthTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  AuthTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(fromJsonApi(json));

  Map<String, dynamic> toJson() => _$AuthTokenResponseToJson(this);
}

extension AuthTokenResponseExtension on AuthTokenResponse {
  AuthToken toAuthToken() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
    );
  }
}
