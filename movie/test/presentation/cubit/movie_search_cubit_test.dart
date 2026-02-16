import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/movie.dart';
import 'package:core/core.dart';

import 'package:bloc_test/bloc_test.dart';
import 'movie_search_cubit_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchCubit movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchCubit(usecase: mockSearchMovies);
  });

  tearDown(() {
    movieSearchBloc.close();
  });

  test('initial state should be initial', () {
    expect(
      movieSearchBloc.state,
      MovieSearchState(searchResult: ViewData.initial()),
    );
  });

  final tMovieModel = MovieEntity(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = <MovieEntity>[tMovieModel];
  final tQuery = 'spiderman';
  final tFailure = ServerFailure('Server Failure');

  group('onQueryChanged', () {
    blocTest<MovieSearchCubit, MovieSearchState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.onQueryChanged(tQuery),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchState(searchResult: ViewData.loading()),
        MovieSearchState(searchResult: ViewData.loaded(data: tMovieList)),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Left(tFailure));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.onQueryChanged(tQuery),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchState(searchResult: ViewData.loading()),
        MovieSearchState(searchResult: ViewData.error(failure: tFailure)),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should emit [NoData] when query is empty',
      build: () => movieSearchBloc,
      act: (bloc) => bloc.onQueryChanged(''),
      expect: () => [MovieSearchState(searchResult: ViewData.noData())],
      verify: (bloc) {
        verifyNever(mockSearchMovies.execute(any));
      },
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should emit [Loading, Loaded] when search returns empty list',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => const Right([]));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.onQueryChanged(tQuery),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchState(searchResult: ViewData.loading()),
        MovieSearchState(searchResult: ViewData.loaded(data: const [])),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should only emit once when multiple queries in debounce window',
      build: () {
        when(
          mockSearchMovies.execute('spiderman'),
        ).thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) {
        bloc.onQueryChanged('s');
        bloc.onQueryChanged('sp');
        bloc.onQueryChanged('spi');
        bloc.onQueryChanged('spid');
        bloc.onQueryChanged('spide');
        bloc.onQueryChanged('spider');
        bloc.onQueryChanged('spiderm');
        bloc.onQueryChanged('spiderma');
        bloc.onQueryChanged('spiderman');
      },
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchState(searchResult: ViewData.loading()),
        MovieSearchState(searchResult: ViewData.loaded(data: tMovieList)),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute('spiderman')).called(1);
        verifyNever(mockSearchMovies.execute('s'));
        verifyNever(mockSearchMovies.execute('sp'));
        verifyNever(mockSearchMovies.execute('spi'));
        verifyNever(mockSearchMovies.execute('spid'));
      },
    );
  });

  group('edge cases', () {
    blocTest<MovieSearchCubit, MovieSearchState>(
      'should handle network timeout',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Left(ServerFailure('Connection Timeout')));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.onQueryChanged(tQuery),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchState(searchResult: ViewData.loading()),
        MovieSearchState(
          searchResult: ViewData.error(
            failure: ServerFailure('Connection Timeout'),
          ),
        ),
      ],
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should handle special characters in query',
      build: () {
        when(
          mockSearchMovies.execute('spider-man: homecoming'),
        ).thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.onQueryChanged('spider-man: homecoming'),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchState(searchResult: ViewData.loading()),
        MovieSearchState(searchResult: ViewData.loaded(data: tMovieList)),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute('spider-man: homecoming'));
      },
    );
  });
}
