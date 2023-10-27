import 'dart:core';

import 'package:flutter_survey/env.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

const _grantType = 'refresh_token';

@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;
  final String grantType = _grantType;
  final String clientId = Env.authClientId;
  final String clientSecret = Env.authClientSecret;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
