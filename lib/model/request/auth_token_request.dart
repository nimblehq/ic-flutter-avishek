import 'dart:core';

import 'package:flutter_survey/env.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token_request.g.dart';

const _grantTypePassword = "password";

@JsonSerializable()
class AuthTokenRequest {
  final String email;
  final String password;
  final String grantType = _grantTypePassword;
  final String clientId = Env.authClientId;
  final String clientSecret = Env.authClientSecret;

  AuthTokenRequest({required this.email, required this.password});

  factory AuthTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenRequestToJson(this);
}
