import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/theme/app_colors.dart';
import 'package:flutter_survey/ui/home/survey_ui_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_survey/ui/widget/skeleton_loading_screen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../di/di.dart';
import '../../usecases/get_surveys_use_case.dart';
import '../widget/home_drawer.dart';
import '../widget/home_footer.dart';
import '../widget/home_header.dart';
import '../widget/survey_page_viewer.dart';
import 'home_state.dart';
import 'home_view_model.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(
    getIt.get<GetSurveysUseCase>(),
  );
});

final _surveysStreamProvider = StreamProvider.autoDispose<List<SurveyUiModel>>(
    (ref) => ref.watch(homeViewModelProvider.notifier).surveysStream);

final surveyPageIndexStreamProvider = StreamProvider.autoDispose<int>(
    (ref) => ref.watch(homeViewModelProvider.notifier).surveyPageIndexStream);

class HomeScreenKey {
  HomeScreenKey._();

  static const btStartSurvey = Key('btHomeStartSurvey');
  static const ivAvatar = Key('ivHomeAvatar');
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uiModels = ref.watch(_surveysStreamProvider).value ?? [];
    return ref.watch(homeViewModelProvider).when(
          init: () => const SkeletonLoadingScreen(),
          loading: () => _buildHomeScreen(uiModels, true),
          success: () => _buildHomeScreen(uiModels, false),
          error: (message) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(message ?? AppLocalizations.of(context)!.errorGeneric),
              ));
            });
            return _buildHomeScreen(uiModels, false);
          },
        );
  }

  Widget _buildHomeScreen(List<SurveyUiModel> surveyUiModels, bool isLoading) {
    return Scaffold(
      endDrawer: const HomeDrawer(),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: AppColors.blackRussian,
        onRefresh: () async {
          ref
              .watch(homeViewModelProvider.notifier)
              .loadSurveys(shouldRefresh: true);
        },
        child: Stack(
          children: <Widget>[
            HomePageView(
              surveyUiModels: surveyUiModels,
              currentPageNotifier: _currentPageNotifier,
            ),
            FractionallySizedBox(
              heightFactor: 0.3,
              child: ListView(),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const HomeHeader(),
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
                    _buildCircleIndicator(surveyUiModels),
                    const SizedBox(height: 26),
                    ValueListenableBuilder(
                      valueListenable: _currentPageNotifier,
                      builder: (_, int value, __) {
                        ref
                            .read(homeViewModelProvider.notifier)
                            .loadMoreSurveys(value);
                        return HomeFooter(
                          survey: surveyUiModels[value],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIndicator(List<SurveyUiModel> surveyUiModels) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CirclePageIndicator(
        size: 8,
        selectedSize: 8,
        dotSpacing: 10,
        dotColor: Colors.white.withOpacity(0.2),
        selectedDotColor: Colors.white,
        itemCount: surveyUiModels.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }
}
