import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/surveydetail/multi_choice_form.dart';
import 'package:flutter_survey/ui/surveydetail/single_selectable_rating_bar.dart';
import 'package:flutter_survey/ui/surveydetail/survey_detail_screen.dart';
import 'package:flutter_survey/utils/extension/iterable_ext.dart';

import '../../model/answer.dart';
import '../../model/question.dart';
import '../widget/nps_bar.dart';
import '../widget/primary_text_form_field_decoration.dart';

const _starEmoji = "⭐️️";
const _heartEmoji = "❤️️";
const _smileys = {0: "😡", 1: "😕", 2: "😐", 3: "🙂", 4: "😄"};

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
          ratingIcon: _starEmoji,
          itemCount: widget.question.answers.length,
          onRate: _saveRating,
        );
      case DisplayType.heart:
        return _buildRating(
          ratingIcon: _heartEmoji,
          itemCount: widget.question.answers.length,
          onRate: _saveRating,
        );
      case DisplayType.smiley:
        return _buildSmileyRating(
          onRate: _saveRating,
        );
      case DisplayType.textarea:
        return _buildTextArea(
          context: context,
          onItemChanged: (text) {
            ref
                .read(surveyDetailViewModelProvider.notifier)
                .saveText(widget.question.id, text);
          },
        );
      case DisplayType.textfield:
        return _buildTextFields(
            context: context,
            answers: widget.question.answers,
            onItemChanged: (answerId, text) {
              ref
                  .read(surveyDetailViewModelProvider.notifier)
                  .saveTextFieldsAnswer(widget.question.id, answerId, text);
            });
      case DisplayType.nps:
        return _buildNps(
            items: widget.question.answers.map((e) => e.text).toList(),
            onRate: _saveRating);
      case DisplayType.choice:
        return _buildMultipleChoice(
          answers: widget.question.answers,
          onItemsChanged: (List<MultiChoiceItem> items) {
            ref
                .read(surveyDetailViewModelProvider.notifier)
                .saveMultiChoiceItems(
                  widget.question.id,
                  items,
                );
          },
        );
      case DisplayType.dropdown:
        return _buildPicker(
            context: context,
            answers: widget.question.answers,
            onSelect: (answer) {
              ref
                  .read(surveyDetailViewModelProvider.notifier)
                  .saveDropdownAnswer(widget.question.id, answer);
            });
      default:
        return const SizedBox.shrink();
    }
  }

  void _saveRating(int rating) {
    ref
        .read(surveyDetailViewModelProvider.notifier)
        .saveRating(widget.question.id, rating);
  }

  Widget _buildPicker({
    required BuildContext context,
    required List<Answer> answers,
    required Function(Answer) onSelect,
  }) {
    onSelect(answers.first);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Picker(
        adapter: PickerDataAdapter<String>(
          data: answers.map((e) => PickerItem(value: e.text)).toList(),
        ),
        textAlign: TextAlign.center,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        selectedTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        selectionOverlay: const DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white, width: 0.5),
              bottom: BorderSide(color: Colors.white, width: 0.5),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        headerColor: Colors.transparent,
        containerColor: Colors.transparent,
        itemExtent: 50,
        hideHeader: true,
        onSelect: (_, __, selected) {
          onSelect(answers[selected.first]);
        },
      ).makePicker(),
    );
  }

  Widget _buildMultipleChoice({
    required List<Answer> answers,
    required Function(List<MultiChoiceItem>) onItemsChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(80.0),
      child: MultiChoiceForm(
        items: answers
            .map((answer) => MultiChoiceItem(answer.id, answer.text))
            .toList(),
        onChanged: onItemsChanged,
      ),
    );
  }

  Widget _buildNps({
    required List<String> items,
    required Function onRate,
  }) {
    return SizedBox(
      height: 120.0,
      child: NpsBar(
        items: items,
        onRatingUpdate: (value) => onRate(value.toInt()),
      ),
    );
  }

  Widget _buildTextFields({
    required BuildContext context,
    required List<Answer> answers,
    required Function onItemChanged,
  }) {
    return Column(
      children: answers
          .map((answer) => Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextFormField(
                  autofocus: true,
                  onChanged: (text) => onItemChanged(answer.id, text),
                  decoration: PrimaryTextFormFieldDecoration(
                    context: context,
                    hint: answer.text,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textInputAction: (answers.last.id != answer.id)
                      ? TextInputAction.next
                      : TextInputAction.done,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTextArea({
    required BuildContext context,
    required Function onItemChanged,
  }) {
    return TextFormField(
      autofocus: true,
      onChanged: (text) => onItemChanged(text),
      decoration: PrimaryTextFormFieldDecoration(
        context: context,
        hint: AppLocalizations.of(context)!.hintYourThoughts,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      maxLines: 5,
    );
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

  Widget _buildSmileyRating({required Function onRate}) {
    final textStyle = Theme.of(context).textTheme.headlineSmall;
    textItem(int index) => Text(_smileys[index]!, style: textStyle);

    return SingleSelectableRatingBar(
      selectedItems:
          widget.question.answers.mapIndexed((_, i) => textItem(i)).toList(),
      unselectedItems: widget.question.answers.mapIndexed((_, i) {
        return Opacity(
          opacity: 0.5,
          child: textItem(i),
        );
      }).toList(),
      onRate: onRate,
    );
  }
}
