import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_state.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_view_model.dart';
import 'package:flutter_survey/ui/surveydetail/survey_intro.dart';
import 'package:go_router/go_router.dart';

import '../../di/di.dart';
import '../../usecases/get_survey_detail_use_case.dart';
import '../home/survey_ui_model.dart';
import '../widget/dimmed_image_background.dart';
import '../widget/loading_indicator.dart';

const Duration _pageScrollDuration = Duration(milliseconds: 200);
const double _initialBackgroundScale = 1;
const double _finalBackgroundScale = 1.5;
const _imageScaleAnimationDurationInMillis = 700;

final shouldZoomInBackgroundProvider =
    StateProvider.autoDispose<bool>((_) => false);

final surveyDetailViewModelProvider =
    StateNotifierProvider.autoDispose<SurveyDetailViewModel, SurveyDetailState>(
        (ref) {
  return SurveyDetailViewModel(
    getIt.get<GetSurveyDetailUseCase>(),
  );
});

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
    final surveyUiModel = widget.surveyUiModel;
    if (surveyUiModel != null) {
      ref
          .read(surveyDetailViewModelProvider.notifier)
          .loadSurveyDetail(surveyUiModel);
    }
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
        _zoomOutAndPop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ref.watch(surveyDetailViewModelProvider).when(
              init: () => const SizedBox.shrink(),
              loading: () => _buildSurveyScreen(widget.surveyUiModel, true),
              success: () => _buildSurveyScreen(widget.surveyUiModel, false),
              error: (message) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message ??
                          AppLocalizations.of(context)!.errorGeneric)));
                });
                return _buildSurveyScreen(widget.surveyUiModel, false);
              },
            ),
      ),
    );
  }

  Widget _buildSurveyScreen(SurveyUiModel? survey, bool isLoading) {
    Future.delayed(Duration.zero, () {
      final shouldZoomInBackground =
      ref.watch(shouldZoomInBackgroundProvider.notifier);
      shouldZoomInBackground.state = true;
    });
    return survey != null
        ? Stack(
            children: [
              Consumer(builder: (_, ref, __) {
                final shouldZoomInBackground =
                    ref.watch(shouldZoomInBackgroundProvider);
                return AnimatedScale(
                  duration: const Duration(
                    milliseconds: _imageScaleAnimationDurationInMillis,
                  ),
                  scale: shouldZoomInBackground
                      ? _finalBackgroundScale
                      : _initialBackgroundScale,
                  child: DimmedImageBackground(
                    image: Image.network(survey.largeCoverImageUrl).image,
                  ),
                );
              }),
              SafeArea(child: _buildSurveyQuestionPager(survey)),
              Center(
                child: isLoading
                    ? const LoadingIndicator()
                    : const SizedBox.shrink(),
              )
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
        onClose: _zoomOutAndPop,
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

  void _zoomOutAndPop() {
    final shouldZoomInBackground =
        ref.watch(shouldZoomInBackgroundProvider.notifier);
    shouldZoomInBackground.state = false;
    Future.delayed(
      const Duration(milliseconds: _imageScaleAnimationDurationInMillis),
      context.pop,
    );
  }
}
