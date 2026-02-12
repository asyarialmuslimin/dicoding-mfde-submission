import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tvseries_remote_data_source.dart';
import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:ditonton/data/models/tvseries_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TVSeriesRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Popular TV Series', () {
    final tTVSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tvseries_popular.json')))
        .tvSeriesList;

    test(
        'should return list of Popular TV Series Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tvseries_popular.json'), 200));

      final result = await dataSource.getPopularTvSeries();
      expect(result, equals(tTVSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Now Playing TV Series', () {
    final tTVSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tvseries_now_playing.json')))
        .tvSeriesList;

    test(
        'should return list of Now Playing TV Series Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tvseries_now_playing.json'), 200));

      final result = await dataSource.getNowPlayingSeries();
      expect(result, equals(tTVSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getNowPlayingSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tTVSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tvseries_top_rated.json')))
        .tvSeriesList;

    test(
        'should return list of Top Rated TV Series Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tvseries_top_rated.json'), 200));

      final result = await dataSource.getTopRatedSeries();
      expect(result, equals(tTVSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series Detail', () {
    final tId = 202250;
    final tTVSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(readJson('dummy_data/tvseries_detail.json')));

    test(
        'should return Detail of TV Series Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tvseries_detail.json'), 200));
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tTVSeriesDetail));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series Recommendations', () {
    final tTVSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tvseries_recommendation.json')))
        .tvSeriesList;
    final tId = 1;

    test('should return list of TV Series Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tvseries_recommendation.json'), 200));
      // act
      final result = await dataSource.getTVSeriesRecommendation(tId);
      // assert
      expect(result, equals(tTVSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVSeriesRecommendation(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/search_mrrobot_tvseries.json')))
        .tvSeriesList;
    final tQuery = 'mr robot';

    test('should return list of TV Series when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_mrrobot_tvseries.json'), 200));
      // act
      final result = await dataSource.searchTVSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTVSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
