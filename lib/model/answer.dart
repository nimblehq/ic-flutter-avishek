import 'package:equatable/equatable.dart';
import 'package:flutter_survey/model/response/answer_response.dart';

class Answer extends Equatable {
  final String id;
  final String text;
  final int displayOrder;
  final String displayType;

  const Answer({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
  });

  @override
  List<Object?> get props => [id, text, displayOrder, displayType];

  factory Answer.fromAnswerResponse(AnswerResponse response) {
    return Answer(
      id: response.id,
      text: response.text ?? "",
      displayOrder: response.displayOrder,
      displayType: response.displayType,
    );
  }
}
