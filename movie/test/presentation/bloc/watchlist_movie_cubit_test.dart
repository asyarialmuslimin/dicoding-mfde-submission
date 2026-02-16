import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/movie.dart';
import 'package:core/core.dart';

import 'watchlist_movie_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieCubit bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  final tMovie = MovieEntity.watchlist(
    id: 1,
    title: 'Test',
    overview: 'Overview',
    posterPath: '/test.jpg',
  );

  final tMovieList = <MovieEntity>[tMovie];
  final tFailure = ServerFailure('Server Failure');

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieCubit(getWatchlistMovies: mockGetWatchlistMovies);
  });

  test('initial state should be ViewData.initial()', () {
    expect(
      bloc.state,
      WatchlistMovieState(watchlistMovies: ViewData.initial()),
    );
  });

  group('onGetWatchlistMovie', () {
    blocTest<WatchlistMovieCubit, WatchlistMovieState>(
      'emit [Loading, HasData] when watchlist movies success',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.onGetWatchlistMovie(), // ✅ Panggil method langsung
      expect: () => [
        WatchlistMovieState(watchlistMovies: ViewData.loading()),
        WatchlistMovieState(watchlistMovies: ViewData.loaded(data: tMovieList)),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieCubit, WatchlistMovieState>(
      'emit [Loading, Error] when watchlist movies failed',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onGetWatchlistMovie(), // ✅ Panggil method langsung
      expect: () => [
        WatchlistMovieState(watchlistMovies: ViewData.loading()),
        WatchlistMovieState(
          watchlistMovies: ViewData.error(
            failure: ServerFailure('Server Failure'),
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieCubit, WatchlistMovieState>(
      'emit [Loading, Loaded] when watchlist movies returns empty list',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.onGetWatchlistMovie(),
      expect: () => [
        WatchlistMovieState(watchlistMovies: ViewData.loading()),
        WatchlistMovieState(watchlistMovies: ViewData.loaded(data: const [])),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}
