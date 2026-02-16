import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMovieCubit])
void main() {
  late MockPopularMovieCubit mockPopularMoviesCubit;

  setUp(() {
    mockPopularMoviesCubit = MockPopularMovieCubit();
  });

  final tMovieList = <MovieEntity>[
    MovieEntity(
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
    ),
  ];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieCubit>.value(
      value: mockPopularMoviesCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    // arrange
    when(mockPopularMoviesCubit.stream).thenAnswer(
      (_) => Stream.value(PopularMovieState(popularMovies: ViewData.loading())),
    );
    when(
      mockPopularMoviesCubit.state,
    ).thenReturn(PopularMovieState(popularMovies: ViewData.loading()));

    // act
    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    await tester.pump();

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    // assert
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    // arrange
    when(mockPopularMoviesCubit.stream).thenAnswer(
      (_) => Stream.value(
        PopularMovieState(popularMovies: ViewData.loaded(data: tMovieList)),
      ),
    );
    when(mockPopularMoviesCubit.state).thenReturn(
      PopularMovieState(popularMovies: ViewData.loaded(data: tMovieList)),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    await tester.pump();

    final listViewFinder = find.byType(ListView);

    // assert
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    // arrange
    const errorMessage = 'Error message';

    when(mockPopularMoviesCubit.stream).thenAnswer(
      (_) => Stream.value(
        PopularMovieState(
          popularMovies: ViewData.error(failure: ServerFailure(errorMessage)),
        ),
      ),
    );
    when(mockPopularMoviesCubit.state).thenReturn(
      PopularMovieState(
        popularMovies: ViewData.error(failure: ServerFailure(errorMessage)),
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    await tester.pump();

    final textFinder = find.byKey(Key('error_message'));

    // assert
    expect(textFinder, findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
