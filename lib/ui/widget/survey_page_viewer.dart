import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import '../home/survey_ui_model.dart';
import 'dimmed_image_background.dart';

class HomePageView extends ConsumerWidget {
  final List<SurveyUiModel> surveyUiModels;
  final ValueNotifier<int> currentPageNotifier;
  final _pageController = PageController();

  HomePageView({
    super.key,
    required this.surveyUiModels,
    required this.currentPageNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<int>>(surveyPageIndexStreamProvider, (_, pageIndex) {
      _pageController.jumpToPage(pageIndex.value ?? 0);
    });
    return PageView.builder(
      itemCount: surveyUiModels.length,
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        return _buildSurveyPageView(context, surveyUiModels[index]);
      },
      onPageChanged: (int index) {
        currentPageNotifier.value = index;
      },
    );
  }

  Widget _buildSurveyPageView(BuildContext context, SurveyUiModel survey) {
    return Stack(
      children: [
        DimmedImageBackground(
          image: Image.network(survey.largeCoverImageUrl).image,
        ),
      ],
    );
  }
}
