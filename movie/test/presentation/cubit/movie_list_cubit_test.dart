import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/movie.dart';
import 'package:core/core.dart';

import 'movie_list_cubit_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListCubit movieListBloc;
  late MockGetNowPlayingMovies mockNowPlaying;
  late MockGetPopularMovies mockPopular;
  late MockGetTopRatedMovies mockTopRated;

  setUp(() {
    mockNowPlaying = MockGetNowPlayingMovies();
    mockPopular = MockGetPopularMovies();
    mockTopRated = MockGetTopRatedMovies();

    movieListBloc = MovieListCubit(
      getNowPlayingMovies: mockNowPlaying,
      getPopularMovies: mockPopular,
      getTopRatedMovies: mockTopRated,
    );
  });

  test('initial state should be initial ViewData', () {
    expect(
      movieListBloc.state,
      MovieListState(
        nowPlayingMovies: ViewData.initial(),
        popularMovies: ViewData.initial(),
        topRatedMovies: ViewData.initial(),
      ),
    );
  });

  final tMovie = MovieEntity.watchlist(
    id: 1,
    title: 'Test Movie',
    overview: 'overview',
    posterPath: '/test.jpg',
  );

  final tMovieList = <MovieEntity>[tMovie];
  final tFailure = ServerFailure('Server Failure');

  group('onGetNowPlayingMovie', () {
    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, HasData] when now playing success',
      build: () {
        when(
          mockNowPlaying.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetNowPlayingMovie(), // ✅ Panggil method langsung
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.loaded(data: tMovieList),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockNowPlaying.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, NoData] when now playing returns empty',
      build: () {
        when(mockNowPlaying.execute()).thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetNowPlayingMovie(),
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.noData(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockNowPlaying.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, Error] when now playing fails',
      build: () {
        when(mockNowPlaying.execute()).thenAnswer((_) async => Left(tFailure));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetNowPlayingMovie(),
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.error(failure: tFailure),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockNowPlaying.execute());
      },
    );
  });

  group('onGetPopularMovie', () {
    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, HasData] when popular success',
      build: () {
        when(mockPopular.execute()).thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetPopularMovie(), // ✅ Panggil method langsung
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.initial(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.loaded(data: tMovieList),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockPopular.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, NoData] when popular returns empty',
      build: () {
        when(mockPopular.execute()).thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetPopularMovie(),
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.initial(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.noData(),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockPopular.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, Error] when popular fails',
      build: () {
        when(mockPopular.execute()).thenAnswer((_) async => Left(tFailure));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetPopularMovie(),
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.initial(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.error(failure: tFailure),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockPopular.execute());
      },
    );
  });

  group('onGetTopRatedMovie', () {
    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, HasData] when top rated success',
      build: () {
        when(mockTopRated.execute()).thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetTopRatedMovie(), // ✅ Panggil method langsung
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.loading(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.loaded(data: tMovieList),
        ),
      ],
      verify: (_) {
        verify(mockTopRated.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, NoData] when top rated returns empty',
      build: () {
        when(mockTopRated.execute()).thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetTopRatedMovie(),
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.loading(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.noData(),
        ),
      ],
      verify: (_) {
        verify(mockTopRated.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit [Loading, Error] when top rated fails',
      build: () {
        when(mockTopRated.execute()).thenAnswer((_) async => Left(tFailure));
        return movieListBloc;
      },
      act: (bloc) => bloc.onGetTopRatedMovie(), // ✅ Panggil method langsung
      expect: () => [
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.loading(),
        ),
        MovieListState(
          nowPlayingMovies: ViewData.initial(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.error(
            failure: ServerFailure('Server Failure'),
          ),
        ),
      ],
      verify: (_) {
        verify(mockTopRated.execute());
      },
    );
  });

  group('concurrent operations', () {
    blocTest<MovieListCubit, MovieListState>(
      'should handle multiple requests independently',
      build: () {
        when(
          mockNowPlaying.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        when(mockPopular.execute()).thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) async {
        bloc.onGetNowPlayingMovie();
        bloc.onGetPopularMovie();
      },
      expect: () => [
        // Now playing loading
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.initial(),
          topRatedMovies: ViewData.initial(),
        ),
        // Popular loading (overwrites previous state)
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.initial(),
        ),
        // Now playing loaded
        MovieListState(
          nowPlayingMovies: ViewData.loaded(data: tMovieList),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.initial(),
        ),
        // Popular loaded
        MovieListState(
          nowPlayingMovies: ViewData.loaded(data: tMovieList),
          popularMovies: ViewData.loaded(data: tMovieList),
          topRatedMovies: ViewData.initial(),
        ),
      ],
      verify: (_) {
        verify(mockNowPlaying.execute());
        verify(mockPopular.execute());
      },
    );
  });
}
