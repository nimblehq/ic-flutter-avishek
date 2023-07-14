import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/api/authentication_service.dart';
import 'package:flutter_survey/di/di.dart';
import 'package:flutter_survey/main.dart';
import 'package:flutter_survey/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../fake/fake_authentication_service.dart';

class TestUtil {
  /// This is useful when we test the whole app with the real configs(styling,
  /// localization, routes, etc)
  static Widget pumpWidgetWithRealApp(String initialRoute) {
    _initDependencies();
    return MyApp();
  }

  /// We normally use this function to test a specific [widget] without
  /// considering much about theming.
  static Widget pumpWidgetWithShellApp(Widget widget) {
    _initDependencies();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: widget,
    );
  }

  static void _initDependencies() {
    PackageInfo.setMockInitialValues(
        appName: 'Survey testing',
        packageName: '',
        version: '',
        buildNumber: '',
        buildSignature: '');
    FlutterConfig.loadValueForTesting({'SECRET': 'This is only for testing'});
  }

  static ProviderScope prepareTestApp(
    Widget homeWidget, {
    Map<String, WidgetBuilder> routes = const {},
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: homeWidget,
        routes: routes,
      ),
    );
  }

  static Future<void> prepareTestEnv() async {
    FlutterConfig.loadValueForTesting({
      'REST_API_ENDPOINT': 'REST_API_ENDPOINT',
      'CLIENT_ID': 'CLIENT_ID',
      'CLIENT_SECRET': 'CLIENT_SECRET',
    });

    await configureInjection();

    getIt.allowReassignment = true;
    getIt.registerSingleton<BaseAuthenticationService>(
        FakeAuthenticationService());
  }
}
