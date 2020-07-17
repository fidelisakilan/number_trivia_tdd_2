import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);
}
//  No need to override the props in abstract class.
//  Instead, you will need to override props in the implemented class.
