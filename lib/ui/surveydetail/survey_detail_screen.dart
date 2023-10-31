import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/model/question.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_state.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_view_model.dart';
import 'package:flutter_survey/ui/surveydetail/survey_intro_page.dart';
import 'package:flutter_survey/ui/surveydetail/survey_question_page.dart';
import 'package:flutter_survey/usecases/submit_survey_use_case.dart';
import 'package:flutter_survey/utils/alert_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../di/di.dart';
import '../../gen/assets.gen.dart';
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
final pageIndexProvider = StateProvider.autoDispose<int>((_) => 0);

final surveyDetailViewModelProvider =
    StateNotifierProvider.autoDispose<SurveyDetailViewModel, SurveyDetailState>(
        (ref) {
  return SurveyDetailViewModel(
    getIt.get<GetSurveyDetailUseCase>(),
    getIt.get<SubmitSurveyUseCase>(),
  );
});

final _surveyStreamProvider = StreamProvider.autoDispose<SurveyUiModel>(
    (ref) => ref.watch(surveyDetailViewModelProvider.notifier).surveyStream);

class SurveyDetailScreenKey {
  SurveyDetailScreenKey._();

  static const btBack = Key('btSurveyDetailBack');
  static const btStart = Key('btSurveyDetailStart');
  static const btClose = Key('btSurveyDetailClose');
  static const btQuestionNext = Key('btSurveyDetailQuestionNext');
  static const btQuestionSubmit = Key('btSurveyDetailQuestionSubmit');
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
  final pages = List.empty(growable: true);

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
    final uiModel = ref.watch(_surveyStreamProvider).value;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ref.watch(surveyDetailViewModelProvider).when(
            init: () => const SizedBox.shrink(),
            loading: () => _buildSurveyScreen(uiModel, true),
            success: () => _buildSurveyScreen(uiModel, false),
            error: (message) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message ??
                        AppLocalizations.of(context)!.errorGeneric)));
              });
              return _buildSurveyScreen(uiModel, false);
            },
            submitted: () {
              // TODO: Navigate to the Thank You screen.
              return _buildSurveyScreen(uiModel, false);
            },
          ),
    );
  }

  Widget _buildSurveyScreen(SurveyUiModel? survey, bool isLoading) {
    Future.delayed(const Duration(milliseconds: 50), () {
      final shouldZoomInBackground =
          ref.watch(shouldZoomInBackgroundProvider.notifier);
      shouldZoomInBackground.state = true;
    });
    return survey != null
        ? WillPopScope(
            onWillPop: () async {
              _showExitConfirmationDialog();
              return false;
            },
            child: Stack(
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
                      shouldAnimate: true,
                    ),
                  );
                }),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer(builder: (_, ref, __) {
                        final isFirstPage = ref.watch(pageIndexProvider) == 0;
                        return _buildToolbar(isFirstPage, () {
                          if (isFirstPage) {
                            _zoomOutAndPop();
                          } else {
                            _showExitConfirmationDialog();
                          }
                        });
                      }),
                      Expanded(child: _buildSurveyQuestionPager(survey))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox.shrink()),
                          Consumer(builder: (_, ref, __) {
                            final index = ref.watch(pageIndexProvider);
                            return _buildActionButton(context, index);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: isLoading
                      ? const LoadingIndicator()
                      : const SizedBox.shrink(),
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildToolbar(bool shouldShowBackButton, Function() onBackOrClose) {
    return shouldShowBackButton
        ? IconButton(
            key: SurveyDetailScreenKey.btBack,
            icon: SizedBox(
              width: 56,
              height: 56,
              child: Assets.icons.icBack
                  .svg(fit: BoxFit.none, width: 56, height: 56),
            ),
            onPressed: onBackOrClose,
          )
        : Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton(
                  key: SurveyDetailScreenKey.btClose,
                  icon: Assets.icons.icClose
                      .svg(fit: BoxFit.none, width: 56, height: 56),
                  onPressed: onBackOrClose,
                ),
              ),
            ],
          );
  }

  Widget _buildActionButton(BuildContext context, int index) {
    if (index == 0) {
      return _buildStartSurveyButton(context);
    } else {
      final isLastPage = index == pages.length - 1;
      if (isLastPage) {
        return _buildSubmitButton();
      } else {
        return _buildNextButton();
      }
    }
  }

  Widget _buildStartSurveyButton(BuildContext context) {
    return TextButton(
      key: SurveyDetailScreenKey.btStart,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black12,
        padding: const EdgeInsets.symmetric(
          vertical: 19,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: _gotoNextPage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(AppLocalizations.of(context)!.startSurvey),
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        key: SurveyDetailScreenKey.btQuestionNext,
        onTap: _gotoNextPage,
        child: ClipOval(
          child: Material(
            color: Colors.white,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Assets.icons.icArrowRight.svg(
                fit: BoxFit.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      key: SurveyDetailScreenKey.btQuestionSubmit,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black12,
        padding: const EdgeInsets.symmetric(
          vertical: 19,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () {
        ref.read(surveyDetailViewModelProvider.notifier).submitSurvey();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(AppLocalizations.of(context)!.submitSurvey),
      ),
    );
  }

  Widget _buildSurveyQuestionPager(SurveyUiModel survey) {
    pages.clear();

    pages.add(
      SurveyIntroPage(
        survey: survey,
      ),
    );

    pages.addAll(
      survey.questions
          .whereNot((element) => element.displayType == DisplayType.intro)
          .mapIndexed((index, question) => SurveyQuestionPage(
                question: question,
                index: index + 1,
                total: survey.questions.length - 1,
              )),
    );

    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: pages.length,
      itemBuilder: (context, i) => pages[i],
    );
  }

  void _gotoNextPage() {
    final pageIndex = ref.watch(pageIndexProvider.notifier);
    pageIndex.state = pageIndex.state + 1;
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

  void _showExitConfirmationDialog() {
    showAppDialog(
      context: context,
      title: AppLocalizations.of(context)!.dialogSurveyExitTitle,
      description: AppLocalizations.of(context)!.dialogSurveyExitDescription,
      positiveButtonText:
          AppLocalizations.of(context)!.dialogSurveyExitPositiveButton,
      negativeButtonText:
          AppLocalizations.of(context)!.dialogSurveyExitNegativeButton,
      onPositiveButtonClick: _zoomOutAndPop,
      onNegativeButtonClick: () {
        // Do nothing and stay on the same screen
      },
    );
  }
}
