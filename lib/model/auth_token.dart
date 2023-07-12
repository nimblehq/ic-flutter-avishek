class AuthToken {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });
}
