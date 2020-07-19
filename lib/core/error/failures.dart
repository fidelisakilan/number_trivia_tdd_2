import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}
//  No need to override the props in abstract class.
//  Instead, you will need to override props in the implemented class.

//these are some general failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
