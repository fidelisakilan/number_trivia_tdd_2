import 'package:number_trivia_tdd_2/features/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

// this because if we had to change from JSON to Gson Or some other form
// we can just change this instead of NumberTrivia CLass itself
class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      //num keyword is cool we get either int or double and that gets converted
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
