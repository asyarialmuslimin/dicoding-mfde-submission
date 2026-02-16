import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/movie.dart';
import 'package:core/core.dart';

import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailCubit bloc;
  late MockGetMovieDetail mockGetDetail;
  late MockGetMovieRecommendations mockGetRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const tId = 1;

  final tMovie = MovieDetail(
    adult: false,
    backdropPath: 'path',
    genres: const [],
    id: tId,
    originalTitle: 'title',
    overview: 'overview',
    posterPath: 'poster',
    releaseDate: 'date',
    runtime: 120,
    title: 'title',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieList = [
    MovieEntity.watchlist(
      id: 2,
      title: 'recommend',
      overview: 'overview',
      posterPath: 'poster',
    ),
  ];

  final tFailure = ServerFailure('Server Failure');

  setUp(() {
    mockGetDetail = MockGetMovieDetail();
    mockGetRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    bloc = MovieDetailCubit(
      getMovieDetail: mockGetDetail,
      getMovieRecommendations: mockGetRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  test('initial state should be ViewData.initial()', () {
    expect(
      bloc.state,
      MovieDetailState(
        movieDetail: ViewData.initial(),
        recommendations: ViewData.initial(),
        watchlistStatus: ViewData.initial(),
        watchlistMessage: ViewData.initial(),
      ),
    );
  });

  group('onGetMovieDetail', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, Loaded] when get detail success',
      build: () {
        when(mockGetDetail.execute(tId)).thenAnswer((_) async => Right(tMovie));
        return bloc;
      },
      act: (bloc) => bloc.onGetMovieDetail(tId), // ✅ Panggil method langsung
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.loading(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.loaded(data: tMovie),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetDetail.execute(tId)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, Error] when get detail failed',
      build: () {
        when(
          mockGetDetail.execute(tId),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onGetMovieDetail(tId),
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.loading(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.error(failure: tFailure),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetDetail.execute(tId)),
    );
  });

  group('onGetMovieRecommendations', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, Loaded] when recommendation success',
      build: () {
        when(
          mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) =>
          bloc.onGetMovieRecommendations(tId), // ✅ Panggil method langsung
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.loading(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.loaded(data: tMovieList),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetRecommendations.execute(tId)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, NoData] when recommendation empty',
      build: () {
        when(
          mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.onGetMovieRecommendations(tId),
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.loading(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.noData(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetRecommendations.execute(tId)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, Error] when recommendation failed',
      build: () {
        when(
          mockGetRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onGetMovieRecommendations(tId),
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.loading(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.error(failure: tFailure),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetRecommendations.execute(tId)),
    );
  });

  group('onGetMovieWatchlistStatus', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, Loaded(true)] when watchlist status is true',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) =>
          bloc.onGetMovieWatchlistStatus(tId), // ✅ Panggil method langsung
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.loading(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.loaded(data: true),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetWatchlistStatus.execute(tId)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit [Loading, Loaded(false)] when watchlist status is false',
      build: () {
        when(
          mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.onGetMovieWatchlistStatus(tId),
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.loading(),
          watchlistMessage: ViewData.initial(),
        ),
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.loaded(data: false),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockGetWatchlistStatus.execute(tId)),
    );
  });

  group('onMovieAddToWatchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit success when add watchlist',
      build: () {
        when(
          mockSaveWatchlist.execute(tMovie),
        ).thenAnswer((_) async => const Right(watchlistAddSuccessMessage));
        return bloc;
      },
      act: (bloc) =>
          bloc.onMovieAddToWatchlist(tMovie), // ✅ Panggil method langsung
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.loaded(data: true),
          watchlistMessage: ViewData.loaded(data: watchlistAddSuccessMessage),
        ),
      ],
      verify: (_) => verify(mockSaveWatchlist.execute(tMovie)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit error when add watchlist failed',
      build: () {
        when(
          mockSaveWatchlist.execute(tMovie),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onMovieAddToWatchlist(tMovie),
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.initial(),
          watchlistMessage: ViewData.error(failure: tFailure),
        ),
      ],
      verify: (_) => verify(mockSaveWatchlist.execute(tMovie)),
    );
  });

  group('onMovieRemoveFromWatchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit success when remove watchlist',
      build: () {
        when(
          mockRemoveWatchlist.execute(tMovie),
        ).thenAnswer((_) async => const Right(watchlistRemoveSuccessMessage));
        return bloc;
      },
      act: (bloc) =>
          bloc.onMovieRemoveFromWatchlist(tMovie), // ✅ Panggil method langsung
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.loaded(data: false),
          watchlistMessage: ViewData.loaded(
            data: watchlistRemoveSuccessMessage,
          ),
        ),
      ],
      verify: (_) => verify(mockRemoveWatchlist.execute(tMovie)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'emit error when remove watchlist failed',
      build: () {
        when(
          mockRemoveWatchlist.execute(tMovie),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onMovieRemoveFromWatchlist(tMovie),
      expect: () => [
        MovieDetailState(
          movieDetail: ViewData.initial(),
          recommendations: ViewData.initial(),
          watchlistStatus: ViewData.error(failure: tFailure),
          watchlistMessage: ViewData.initial(),
        ),
      ],
      verify: (_) => verify(mockRemoveWatchlist.execute(tMovie)),
    );
  });
}
