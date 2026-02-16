import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListCubit])
void main() {
  late MockMovieListCubit mockMovieListCubit;

  setUp(() {
    mockMovieListCubit = MockMovieListCubit();
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
    return BlocProvider<MovieListCubit>.value(
      value: mockMovieListCubit,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == WatchlistMoviesPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Watchlist Page'))),
            );
          } else if (settings.name == SearchPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Search Page'))),
            );
          } else if (settings.name == PopularMoviesPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Popular Page'))),
            );
          } else if (settings.name == TopRatedMoviesPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Top Rated Page'))),
            );
          } else if (settings.name == aboutRoute) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(body: Center(child: Text('About Page'))),
            );
          }
          return null;
        },
      ),
    );
  }

  group('HomeMoviePage', () {
    testWidgets('should display AppBar with correct title and actions', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.loading(),
            popularMovies: ViewData.loading(),
            topRatedMovies: ViewData.loading(),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

      // assert
      expect(find.text('Ditonton : Movie'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display loading indicators when fetching data', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.loading(),
            popularMovies: ViewData.loading(),
            topRatedMovies: ViewData.loading(),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should display movie lists when data is loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.loaded(data: tMovieList),
            popularMovies: ViewData.loaded(data: tMovieList),
            topRatedMovies: ViewData.loaded(data: tMovieList),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.loaded(data: tMovieList),
          popularMovies: ViewData.loaded(data: tMovieList),
          topRatedMovies: ViewData.loaded(data: tMovieList),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

      // assert
      expect(find.byType(MovieList), findsNWidgets(3));
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('should trigger fetch events when page is initialized', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.loading(),
            popularMovies: ViewData.loading(),
            topRatedMovies: ViewData.loading(),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));
      await tester.pump();

      // assert
      verify(mockMovieListCubit.onGetNowPlayingMovie()).called(1);
      verify(mockMovieListCubit.onGetPopularMovie()).called(1);
      verify(mockMovieListCubit.onGetTopRatedMovie()).called(1);
    });

    testWidgets('should navigate to search page when search icon is tapped', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.loading(),
            popularMovies: ViewData.loading(),
            topRatedMovies: ViewData.loading(),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.loading(),
          popularMovies: ViewData.loading(),
          topRatedMovies: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Search Page'), findsOneWidget);
    });

    testWidgets('should display error message when error occurs', (
      WidgetTester tester,
    ) async {
      // arrange
      const errorMessage = 'Failed to load movies';

      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.error(
              failure: ServerFailure(errorMessage),
            ),
            popularMovies: ViewData.error(failure: ServerFailure(errorMessage)),
            topRatedMovies: ViewData.error(
              failure: ServerFailure(errorMessage),
            ),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.error(
            failure: ServerFailure(errorMessage),
          ),
          popularMovies: ViewData.error(failure: ServerFailure(errorMessage)),
          topRatedMovies: ViewData.error(failure: ServerFailure(errorMessage)),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

      // assert
      expect(find.text(errorMessage), findsNWidgets(3));
    });

    testWidgets('should display empty message when no data available', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieListCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieListState(
            nowPlayingMovies: ViewData.noData(),
            popularMovies: ViewData.noData(),
            topRatedMovies: ViewData.noData(),
          ),
        ),
      );
      when(mockMovieListCubit.state).thenReturn(
        MovieListState(
          nowPlayingMovies: ViewData.noData(),
          popularMovies: ViewData.noData(),
          topRatedMovies: ViewData.noData(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

      // assert
      expect(find.text('No movies available'), findsNWidgets(3));
    });
  });
}
