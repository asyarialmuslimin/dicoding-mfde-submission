import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/movie.dart';
import 'package:core/core.dart';

import 'top_rated_movie_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMovieCubit bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  final tMovie = MovieEntity.watchlist(
    id: 1,
    title: 'Test',
    overview: 'Overview',
    posterPath: '/test.jpg',
  );

  final tMovieList = <MovieEntity>[tMovie];
  final tFailure = ServerFailure('Server Failure');

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMovieCubit(getTopRatedMovies: mockGetTopRatedMovies);
  });

  test('initial state should be ViewData.initial()', () {
    expect(bloc.state, TopRatedMovieState(topRatedMovies: ViewData.initial()));
  });

  group('onGetTopRatedMovie', () {
    blocTest<TopRatedMovieCubit, TopRatedMovieState>(
      'emit [Loading, HasData] when top rated movies success',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.onGetTopRatedMovie(), // ✅ Panggil method langsung
      expect: () => [
        TopRatedMovieState(topRatedMovies: ViewData.loading()),
        TopRatedMovieState(topRatedMovies: ViewData.loaded(data: tMovieList)),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMovieCubit, TopRatedMovieState>(
      'emit [Loading, Error] when top rated movies failed',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.onGetTopRatedMovie(), // ✅ Panggil method langsung
      expect: () => [
        TopRatedMovieState(topRatedMovies: ViewData.loading()),
        TopRatedMovieState(
          topRatedMovies: ViewData.error(
            failure: ServerFailure('Server Failure'),
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMovieCubit, TopRatedMovieState>(
      'emit [Loading, Loaded] when top rated movies returns empty list',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.onGetTopRatedMovie(),
      expect: () => [
        TopRatedMovieState(topRatedMovies: ViewData.loading()),
        TopRatedMovieState(topRatedMovies: ViewData.loaded(data: const [])),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
