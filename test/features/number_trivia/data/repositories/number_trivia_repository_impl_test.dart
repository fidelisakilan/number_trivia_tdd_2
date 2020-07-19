import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_tdd_2/core/error/exceptions.dart';
import 'package:number_trivia_tdd_2/core/error/failures.dart';
import 'package:number_trivia_tdd_2/core/network/network_info.dart';
import 'package:number_trivia_tdd_2/features/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_tdd_2/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tdd_2/features/data/models/number_trivia_model.dart';
import 'package:number_trivia_tdd_2/features/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_tdd_2/features/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('get concrete number trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test trivia', number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(1);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return SERVER FAilure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestOffline(() {
      test('should return last locally cached data when cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should return CacheFailure when ther is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('get random number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test trivia', number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();

        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return SERVER FAilure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestOffline(() {
      test('should return last locally cached data when cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should return CacheFailure when ther is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
