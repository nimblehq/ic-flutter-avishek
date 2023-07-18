import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/theme/app_colors.dart';
import 'package:flutter_survey/ui/home/survey_ui_model.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../widget/home_drawer.dart';
import '../widget/home_footer.dart';
import '../widget/home_header.dart';
import '../widget/survey_page_viewer.dart';

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
    // TODO: replace them with API data in the integrate task.
    var surveyUiModels = [
      const SurveyUiModel(
        id: "1",
        title: "Title 1",
        description: "Description 1",
        coverImageUrl:
            "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_",
      ),
      const SurveyUiModel(
        id: "2",
        title: "Title 2",
        description: "Description 2",
        coverImageUrl:
            "https://dhdbhh0jsld0o.cloudfront.net/m/287db81c5e4242412cc0_",
      ),
      const SurveyUiModel(
        id: "3",
        title: "Title 3",
        description: "Description 3",
        coverImageUrl:
            "https://dhdbhh0jsld0o.cloudfront.net/m/0221e768b99dc3576210_",
      )
    ];
    return _buildHomeScreen(surveyUiModels);
  }

  Widget _buildHomeScreen(List<SurveyUiModel> surveyUiModels) {
    return Scaffold(
      endDrawer: const HomeDrawer(),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: AppColors.blackRussian,
        onRefresh: () async {
          // TODO: add refresh logic.
        },
        child: Stack(
          children: <Widget>[
            HomePageView(
              surveyUiModels: surveyUiModels,
              currentPageNotifier: _currentPageNotifier,
            ),
            // Workaround to allow the page to be scrolled vertically to refresh on top
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
