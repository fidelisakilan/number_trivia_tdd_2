import 'package:dartz/dartz.dart';
import 'package:number_trivia_tdd_2/core/error/failures.dart';
import 'package:number_trivia_tdd_2/features/domain/entities/number_trivia.dart';
import 'package:number_trivia_tdd_2/features/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
  Future<Either<Failure, NumberTrivia>> execute({@required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
