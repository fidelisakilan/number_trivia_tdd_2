import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia_tdd_2/core/network/network_info.dart';
import 'package:number_trivia_tdd_2/core/util/input_converter.dart';
import 'package:number_trivia_tdd_2/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tdd_2/features/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_tdd_2/features/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_tdd_2/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_tdd_2/features/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_tdd_2/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/data/datasources/number_trivia_local_data_source.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! Features -NumberTrivia
  //Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  //use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  //Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! Core stuff
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
