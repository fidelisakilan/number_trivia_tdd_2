import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_tdd_2/core/error/exceptions.dart';
import 'package:number_trivia_tdd_2/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tdd_2/features/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  //method of a mocked class which arent setUP will always return null

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something wornog", 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number being 
    the endpoint with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a server exception when response code is 404', () async {
      //arrange
      setUpMockHttpClientFailure404();

      //act
      final call = dataSource.getConcreteNumberTrivia;

      //assert
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number being 
    the endpoint with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a server exception when response code is 404', () async {
      //arrange
      setUpMockHttpClientFailure404();

      //act
      final call = dataSource.getRandomNumberTrivia;

      //assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
