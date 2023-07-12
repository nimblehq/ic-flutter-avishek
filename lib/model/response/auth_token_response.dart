import 'package:flutter_survey/model/AuthToken.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token_response.g.dart';

@JsonSerializable()
class AuthTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  AuthTokenResponse(
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  );

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(json);

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
