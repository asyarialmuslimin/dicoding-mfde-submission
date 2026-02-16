import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/movie.dart';
import 'package:core/core.dart';

import 'popular_movie_cubit_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieCubit bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  final tMovie = MovieEntity.watchlist(
    id: 1,
    title: 'Test',
    overview: 'Overview',
    posterPath: '/test.jpg',
  );

  final tMovieList = <MovieEntity>[tMovie];
  final tFailure = ServerFailure('Server Failure');

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMovieCubit(getPopularMovies: mockGetPopularMovies);
  });

  test('initial state should be ViewData.initial()', () {
    expect(bloc.state, PopularMovieState(popularMovies: ViewData.initial()));
  });

  group('onGetPopularMovie', () {
    blocTest<PopularMovieCubit, PopularMovieState>(
      'emit [Loading, HasData] when popular movies success',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.onGetPopularMovie(), // ✅ Panggil method langsung
      expect: () => [
        PopularMovieState(popularMovies: ViewData.loading()),
        PopularMovieState(popularMovies: ViewData.loaded(data: tMovieList)),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMovieCubit, PopularMovieState>(
      'emit [Loading, Error] when popular movies failed',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onGetPopularMovie(), // ✅ Panggil method langsung
      expect: () => [
        PopularMovieState(popularMovies: ViewData.loading()),
        PopularMovieState(
          popularMovies: ViewData.error(
            failure: ServerFailure('Server Failure'),
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMovieCubit, PopularMovieState>(
      'emit [Loading, Loaded] when popular movies returns empty list',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.onGetPopularMovie(),
      expect: () => [
        PopularMovieState(popularMovies: ViewData.loading()),
        PopularMovieState(popularMovies: ViewData.loaded(data: const [])),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
