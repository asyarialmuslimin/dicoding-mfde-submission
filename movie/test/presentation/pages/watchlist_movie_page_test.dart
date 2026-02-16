import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'watchlist_movie_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieCubit])
void main() {
  late MockWatchlistMovieCubit mockWatchlistMovieCubit;

  setUp(() {
    mockWatchlistMovieCubit = MockWatchlistMovieCubit();
  });

  final tMovie = MovieEntity(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-01-01',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieList = <MovieEntity>[tMovie];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieCubit>.value(
      value: mockWatchlistMovieCubit,
      child: MaterialApp(home: body),
    );
  }

  group('WatchlistMoviesPage', () {
    testWidgets('should display loading indicator when loading', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockWatchlistMovieCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(watchlistMovies: ViewData.loading()),
        ),
      );
      when(
        mockWatchlistMovieCubit.state,
      ).thenReturn(WatchlistMovieState(watchlistMovies: ViewData.loading()));

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display list of movies when data is loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockWatchlistMovieCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistMovies: ViewData.loaded(data: tMovieList),
          ),
        ),
      );
      when(mockWatchlistMovieCubit.state).thenReturn(
        WatchlistMovieState(watchlistMovies: ViewData.loaded(data: tMovieList)),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsOneWidget);
    });

    testWidgets('should display error message when error occurs', (
      WidgetTester tester,
    ) async {
      // arrange
      const errorMessage = 'Failed to load watchlist';

      when(mockWatchlistMovieCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistMovies: ViewData.error(
              failure: DatabaseFailure(errorMessage),
            ),
          ),
        ),
      );
      when(mockWatchlistMovieCubit.state).thenReturn(
        WatchlistMovieState(
          watchlistMovies: ViewData.error(
            failure: DatabaseFailure(errorMessage),
          ),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      // assert
      expect(find.byKey(Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should trigger fetch event when page is first loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockWatchlistMovieCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistMovies: ViewData.loaded(data: tMovieList),
          ),
        ),
      );
      when(mockWatchlistMovieCubit.state).thenReturn(
        WatchlistMovieState(watchlistMovies: ViewData.loaded(data: tMovieList)),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));
      await tester.pump();

      // assert
      verify(mockWatchlistMovieCubit.onGetWatchlistMovie()).called(1);
    });

    testWidgets('should display correct number of movies in watchlist', (
      WidgetTester tester,
    ) async {
      // arrange
      final tMultipleMovies = <MovieEntity>[
        tMovie,
        MovieEntity(
          adult: false,
          backdropPath: '/path2.jpg',
          genreIds: [2],
          id: 2,
          originalTitle: 'Original Title 2',
          overview: 'Overview 2',
          popularity: 2.0,
          posterPath: '/path2.jpg',
          releaseDate: '2021-01-01',
          title: 'Title 2',
          video: false,
          voteAverage: 9.0,
          voteCount: 200,
        ),
      ];

      when(mockWatchlistMovieCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistMovies: ViewData.loaded(data: tMultipleMovies),
          ),
        ),
      );
      when(mockWatchlistMovieCubit.state).thenReturn(
        WatchlistMovieState(
          watchlistMovies: ViewData.loaded(data: tMultipleMovies),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

      // assert
      expect(find.byType(MovieCard), findsNWidgets(2));
    });
  });
}
