import 'dart:core';

import 'package:flutter_survey/env.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

const _grantType = 'refresh_token';

@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;
  late String grantType = _grantType;
  late String clientId = Env.authClientId;
  late String clientSecret = Env.authClientSecret;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
