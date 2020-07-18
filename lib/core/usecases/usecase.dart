import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_tdd_2/core/error/failures.dart';
import 'package:number_trivia_tdd_2/features/domain/entities/number_trivia.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
