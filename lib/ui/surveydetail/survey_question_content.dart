import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/question.dart';

const starEmoji = "⭐️️";
const heartEmoji = "❤️️";

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
}
