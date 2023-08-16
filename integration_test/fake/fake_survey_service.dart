import 'package:flutter_survey/api/survey_service.dart';
import 'package:flutter_survey/model/response/survey_list_response.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_data.dart';

const String surveysKey = 'surveys';

class FakeSurveyService extends Fake implements BaseSurveyService {
  @override
  Future<SurveyListResponse> getSurveys(int pageNumber, int pageSize) async {
    final response = FakeData.fakeResponses[surveysKey]!;

    if (response.statusCode != 200) {
      throw fakeDioException(response.statusCode);
    }
    return SurveyListResponse.fromJson(response.json);
  }
}
