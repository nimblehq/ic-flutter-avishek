import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/surveydetail/single_selectable_rating_bar.dart';
import 'package:flutter_survey/utils/extension/iterable_ext.dart';

import '../../model/question.dart';

const starEmoji = "⭐️️";
const heartEmoji = "❤️️";
const smileys = {0: "😡", 1: "😕", 2: "😐", 3: "🙂", 4: "😄"};

class SurveyQuestionContent extends ConsumerStatefulWidget {
  final Question question;

  const SurveyQuestionContent({super.key, required this.question});

  @override
  SurveyQuestionContentState createState() {
    return SurveyQuestionContentState();
  }
}

class SurveyQuestionContentState extends ConsumerState<SurveyQuestionContent> {
  @override
  Widget build(BuildContext context) {
    switch (widget.question.displayType) {
      case DisplayType.star:
        return _buildRating(
          ratingIcon: starEmoji,
          itemCount: widget.question.answers.length,
          onRate: (rating) {
            // TODO: Implement in the Integrate task
          },
        );
      case DisplayType.heart:
        return _buildRating(
          ratingIcon: heartEmoji,
          itemCount: widget.question.answers.length,
          onRate: (rating) {
            // TODO: Implement in the Integrate task
          },
        );
      case DisplayType.smiley:
        return _buildSmileyRating();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRating({
    required String ratingIcon,
    required int itemCount,
    required Function onRate,
  }) {
    return RatingBar(
      itemCount: itemCount,
      ratingWidget: RatingWidget(
        full: Text(ratingIcon),
        half: const SizedBox.shrink(),
        empty: Opacity(
          opacity: 0.5,
          child: Text(ratingIcon),
        ),
      ),
      onRatingUpdate: (rating) => onRate(rating.toInt()),
    );
  }

  Widget _buildSmileyRating() {
    final textStyle = Theme.of(context).textTheme.headlineSmall;
    textItem(int index) => Text(smileys[index]!, style: textStyle);

    return SingleSelectableRatingBar(
      selectedItems:
          widget.question.answers.mapIndexed((_, i) => textItem(i)).toList(),
      unselectedItems: widget.question.answers.mapIndexed((_, i) {
        return Opacity(
          opacity: 0.5,
          child: textItem(i),
        );
      }).toList(),
      onRate: () {
        //TODO: implement later.
      },
    );
  }
}
