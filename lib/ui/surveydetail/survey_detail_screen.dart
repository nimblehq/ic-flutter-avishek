import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/surveydetail/survey_intro.dart';
import 'package:go_router/go_router.dart';

import '../home/survey_ui_model.dart';
import '../widget/dimmed_image_background.dart';

const Duration _pageScrollDuration = Duration(milliseconds: 200);
const double _initialBackgroundScale = 1;
const double _finalBackgroundScale = 1.5;
const _imageScaleAnimationDurationInMillis = 700;

final shouldAnimateBackgroundScaleProvider =
    StateProvider.autoDispose<bool>((_) => false);

class SurveyDetailScreenKey {
  SurveyDetailScreenKey._();

  static const btBack = Key('btSurveyDetailBack');
  static const btStart = Key('btSurveyDetailStart');
  static const btClose = Key('btSurveyDetailClose');
}

class SurveyDetailScreen extends ConsumerStatefulWidget {
  final SurveyUiModel? surveyUiModel;

  const SurveyDetailScreen({super.key, this.surveyUiModel});

  @override
  SurveyDetailScreenState createState() {
    return SurveyDetailScreenState();
  }
}

class SurveyDetailScreenState extends ConsumerState<SurveyDetailScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final shouldAnimateBackgroundScale =
          ref.watch(shouldAnimateBackgroundScaleProvider.notifier);
      shouldAnimateBackgroundScale.state = !shouldAnimateBackgroundScale.state;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _animateScaleAndPop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildSurveyScreen(widget.surveyUiModel),
      ),
    );
  }

  Widget _buildSurveyScreen(SurveyUiModel? survey) {
    return survey != null
        ? Stack(
            children: [
              Consumer(builder: (_, ref, __) {
                final shouldAnimateBackgroundScale =
                    ref.watch(shouldAnimateBackgroundScaleProvider);
                return AnimatedScale(
                  duration: const Duration(
                    milliseconds: _imageScaleAnimationDurationInMillis,
                  ),
                  scale: shouldAnimateBackgroundScale
                      ? _finalBackgroundScale
                      : _initialBackgroundScale,
                  child: DimmedImageBackground(
                    image: Image.network(survey.largeCoverImageUrl).image,
                  ),
                );
              }),
              SafeArea(child: _buildSurveyQuestionPager(survey)),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildSurveyQuestionPager(SurveyUiModel survey) {
    final pages = List.empty(growable: true);
    pages.add(
      SurveyIntro(
        survey: survey,
        onNext: () => _gotoNextPage(),
        onClose: _animateScaleAndPop,
      ),
    );

    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: pages.length,
      itemBuilder: (context, i) => pages[i],
    );
  }

  void _gotoNextPage() {
    _pageController.nextPage(
      duration: _pageScrollDuration,
      curve: Curves.ease,
    );
  }

  void _animateScaleAndPop() {
    final shouldAnimateBackgroundScale =
        ref.watch(shouldAnimateBackgroundScaleProvider.notifier);
    shouldAnimateBackgroundScale.state = !shouldAnimateBackgroundScale.state;
    Future.delayed(
      const Duration(milliseconds: _imageScaleAnimationDurationInMillis),
      context.pop,
    );
  }
}
