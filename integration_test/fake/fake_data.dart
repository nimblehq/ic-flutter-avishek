import 'package:dio/dio.dart';

class FakeResponse {
  final int statusCode;
  final Map<String, dynamic> json;

  FakeResponse(this.statusCode, this.json);
}

class FakeData {
  FakeData._();

  static Map<String, FakeResponse> fakeResponses = {};

  static void addSuccessResponse(String key, Map<String, dynamic> response) {
    final newValue = FakeResponse(200, response);
    fakeResponses.update(key, (value) => newValue, ifAbsent: () => newValue);
  }

  static void addErrorResponse(String key) {
    final newValue = FakeResponse(400, {});
    fakeResponses.update(key, (value) => newValue, ifAbsent: () => newValue);
  }
}

DioException fakeDioException(int statusCode) {
  return DioException(
      response: Response(
          statusCode: statusCode, requestOptions: RequestOptions(path: '')),
      type: DioExceptionType.badResponse,
      requestOptions: RequestOptions(path: ''));
}
