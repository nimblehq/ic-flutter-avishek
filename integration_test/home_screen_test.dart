import 'package:flutter_survey/ui/home/home_screen.dart';
import 'package:flutter_survey/utils/extension/date_time_ext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'fake/fake_data.dart';
import 'fake/fake_survey_service.dart';
import 'utils/file_util.dart';
import 'utils/test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Screen Test', () {
    late Map<String, dynamic> surveysJson;

    setUpAll(() async {
      await TestUtil.prepareTestEnv();
    });

    setUp(() async {
      surveysJson = await FileUtil.loadFile('test_resources/surveys.json');
    });

    testWidgets("When starting, it displays correct info",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestUtil.prepareTestApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(
          find.text(DateTime.now().toFormattedFullDayMonthYear().toUpperCase()),
          findsOneWidget);
      expect(find.text("Today"), findsOneWidget);
    });

    testWidgets(
        "When loading surveys successfully, it shows correct survey data",
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(surveysKey, surveysJson);
      await tester.pumpWidget(TestUtil.prepareTestApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // Verify first survey page
      final survey1 = surveysJson['data'][0];
      expect(find.text(survey1['title']), findsOneWidget);
      expect(find.text(survey1['description']), findsOneWidget);

      // Swipe to next page
      await tester.flingFrom(
          const Offset(100, 300), const Offset(-100, 0), 500);
      await tester.pumpAndSettle();

      // Verify second survey page
      final survey2 = surveysJson['data'][1];
      expect(find.text(survey2['title']), findsOneWidget);
      expect(find.text(survey2['description']), findsOneWidget);
    });
  });
}
