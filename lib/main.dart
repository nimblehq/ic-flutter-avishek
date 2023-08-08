import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/di/di.dart';
import 'package:flutter_survey/theme/app_theme.dart';
import 'package:flutter_survey/ui/home/home_screen.dart';
import 'package:flutter_survey/ui/home/survey_ui_model.dart';
import 'package:flutter_survey/ui/login/login_screen.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_screen.dart';
import 'package:flutter_survey/utils/util.dart';
import 'package:go_router/go_router.dart';

import 'local/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await initHive();
  await configureInjection();

  runApp(ProviderScope(child: MyApp()));
}

const routePathRootScreen = '/';
const routePathHomeScreen = 'home';
const routePathSurveyDetailScreen = 'survey-detail';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: routePathRootScreen,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
        routes: [
          GoRoute(
            path: routePathHomeScreen,
            builder: (BuildContext context, GoRouterState state) =>
                const HomeScreen(),
          ),
          GoRoute(
            path: routePathSurveyDetailScreen,
            name: routePathSurveyDetailScreen,
            builder: (BuildContext context, GoRouterState state) {
              final surveyUiModel = state.extra as SurveyUiModel;
              return SurveyDetailScreen(surveyUiModel: surveyUiModel);
            },
            pageBuilder: (BuildContext context, GoRouterState state) {
              final surveyUiModel = state.extra as SurveyUiModel;
              return Util.buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: SurveyDetailScreen(surveyUiModel: surveyUiModel),
              );
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme:
          AppTheme.light.copyWith(scaffoldBackgroundColor: Colors.transparent),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
