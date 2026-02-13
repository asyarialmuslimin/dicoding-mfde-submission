import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesRepositoryImpl repository;
  late MockTVSeriesRemoteDataSource mockRemoteDataSource;
  late MockTVSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVSeriesRemoteDataSource();
    mockLocalDataSource = MockTVSeriesLocalDataSource();
    repository = TVSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [18, 80],
    id: 62560,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Mr. Robot',
    overview:
        'A young programmer, Elliot, suffers from a debilitating anti-social disorder and decides that he can only connect to people by hacking them.',
    popularity: 37.3808,
    posterPath: '/kv1nRqgebSsREnd7vdC2pSGjpLo.jpg',
    firstAirDate: '2015-06-24',
    name: 'Mr. Robot',
    voteAverage: 8.264,
    voteCount: 5162,
  );

  final tTVSeries = TvSeriesEntity(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [18, 80],
    id: 62560,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Mr. Robot',
    overview:
        'A young programmer, Elliot, suffers from a debilitating anti-social disorder and decides that he can only connect to people by hacking them.',
    popularity: 37.3808,
    posterPath: '/kv1nRqgebSsREnd7vdC2pSGjpLo.jpg',
    firstAirDate: '2015-06-24',
    name: 'Mr. Robot',
    voteAverage: 8.264,
    voteCount: 5162,
  );

  final tTVSeriesModelList = <TvSeriesModel>[tTVSeriesModel];
  final tTVSeriesList = <TvSeriesEntity>[tTVSeries];

  group('Now Playing TV Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.getNowPlayingTVSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingSeries());

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingTVSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingSeries());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getNowPlayingTVSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingSeries());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular TV Series', () {
    test(
      'should return TV series list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.getPopularTVSeries();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTVSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTVSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TV Series', () {
    test(
      'should return TV series list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.getTopRatedTVSeries();
        // assert

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTVSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTVSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Series Detail', () {
    final tId = 1;
    final tTVSeriesResponse = TvSeriesDetailModel(
      adult: false,
      backdropPath: 'backdropPath',
      episodeRunTime: [45],
      firstAirDate: 'firstAirDate',
      genres: [GenreModel(id: 1, name: 'Drama')],
      homepage: 'https://google.com',
      id: 1,
      inProduction: false,
      languages: ['en'],
      lastAirDate: 'lastAirDate',
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'posterPath',
      status: 'Ended',
      tagline: 'tagline',
      type: 'Scripted',
      voteAverage: 1.0,
      voteCount: 1,
      lastEpisodeToAir: LastEpisodeToAirModel(
        id: 1,
        name: 'name',
        overview: 'overview',
        voteAverage: 1.0,
        voteCount: 1,
        airDate: 'airDate',
        episodeNumber: 1,
        episodeType: 'episodeType',
        productionCode: 'productionCode',
        runtime: 1,
        seasonNumber: 1,
        showId: 1,
        stillPath: 'stillPath',
      ),
      seasons: [
        TVSeriesSeasonModel(
          airDate: 'airDate',
          episodeCount: 1,
          id: 1,
          name: 'name',
          overview: 'overview',
          posterPath: 'posterPath',
          seasonNumber: 1,
          voteAverage: 1.0,
        ),
      ],
    );

    test(
      'should return TV Series data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenAnswer((_) async => tTVSeriesResponse);
        // act
        final result = await repository.getTVSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(Right(testTVSeriesDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTVSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Series Recommendations', () {
    final tTVSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test(
      'should return data (TV series list) when the call is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeriesRecommendation(tId),
        ).thenAnswer((_) async => tTVSeriesList);
        // act
        final result = await repository.getTVSeriesRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTVSeriesRecommendation(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTVSeriesList));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeriesRecommendation(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTVSeriesRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTVSeriesRecommendation(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeriesRecommendation(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVSeriesRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTVSeriesRecommendation(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Search TV Series', () {
    final tQuery = 'mr robot';

    test(
      'should return TV series list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTVSeries(tQuery),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.searchTVSeries(tQuery);
        // assert

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTVSeries(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTVSeries(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTVSeries(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTVSeries(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(
        mockLocalDataSource.getTVSeriesById(tId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist TV series', () {
    test('should return list of TV Series', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTVSeries(),
      ).thenAnswer((_) async => [testTVSeriesTable]);
      // act
      final result = await repository.getWatchlistTVSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTVSeries]);
    });
  });
}
