import 'package:flutter/cupertino.dart';
import 'package:flutter_survey/main.dart';
import 'package:flutter_survey/ui/home/home_screen.dart';
import 'package:flutter_survey/ui/login/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'fake/fake_authentication_service.dart';
import 'fake/fake_data.dart';
import 'utils/file_util.dart';
import 'utils/test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Page Test', () {
    late Map<String, dynamic> loginJson;

    late Finder tfEmail;
    late Finder tfPassword;
    late Finder btLogin;

    setUpAll(() async {
      await TestUtil.prepareTestEnv();
    });

    setUp(() async {
      loginJson = await FileUtil.loadFile('test_resources/login.json');

      tfEmail = find.byKey(LoginScreenKey.tfEmail);
      tfPassword = find.byKey(LoginScreenKey.tfPassword);
      btLogin = find.byKey(LoginScreenKey.btLogin);
    });

    testWidgets(
        "When starting the login screen, it displays the UI components correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestUtil.prepareTestApp(const LoginScreen()));

      await tester.pumpAndSettle();
      expect(tfEmail, findsOneWidget);
      expect(tfPassword, findsOneWidget);
      expect(btLogin, findsOneWidget);
    });

    testWidgets(
        "When logging with invalid email or password, it shows the error message",
        (WidgetTester tester) async {
      FakeData.addErrorResponse(loginKey);
      await tester.pumpWidget(TestUtil.prepareTestApp(const LoginScreen()));

      await tester.pumpAndSettle();
      await tester.enterText(tfEmail, 'test@abc.com');
      await tester.enterText(tfPassword, '12345678');
      await tester.tap(btLogin);

      await tester.pumpAndSettle();
      expect(find.text('Login failed! Please recheck your email or password'),
          findsOneWidget);
    });

    // TODO: change the test to assert navigation to home.
    testWidgets(
        "When logging with valid email and password, it shows the success message",
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(loginKey, loginJson);
      await tester.pumpWidget(
        TestUtil.prepareTestApp(
          const LoginScreen(),
          routes: <String, WidgetBuilder>{
            routePathHomeScreen: (BuildContext context) => const HomeScreen()
          },
        ),
      );

      await tester.pumpAndSettle();
      await tester.enterText(tfEmail, 'test@abc.com');
      await tester.enterText(tfPassword, '12345678');
      await tester.tap(btLogin);

      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
