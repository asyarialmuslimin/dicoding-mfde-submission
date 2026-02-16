import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMovieCubit])
void main() {
  late MockTopRatedMovieCubit mockTopRatedMovieCubit;

  setUp(() {
    mockTopRatedMovieCubit = MockTopRatedMovieCubit();
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
    return BlocProvider<TopRatedMovieCubit>.value(
      value: mockTopRatedMovieCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    // arrange
    when(mockTopRatedMovieCubit.stream).thenAnswer(
      (_) =>
          Stream.value(TopRatedMovieState(topRatedMovies: ViewData.loading())),
    );
    when(
      mockTopRatedMovieCubit.state,
    ).thenReturn(TopRatedMovieState(topRatedMovies: ViewData.loading()));

    // act
    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump();

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    // assert
    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    // arrange
    when(mockTopRatedMovieCubit.stream).thenAnswer(
      (_) => Stream.value(
        TopRatedMovieState(topRatedMovies: ViewData.loaded(data: tMovieList)),
      ),
    );
    when(mockTopRatedMovieCubit.state).thenReturn(
      TopRatedMovieState(topRatedMovies: ViewData.loaded(data: tMovieList)),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));
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

    when(mockTopRatedMovieCubit.stream).thenAnswer(
      (_) => Stream.value(
        TopRatedMovieState(
          topRatedMovies: ViewData.error(failure: ServerFailure(errorMessage)),
        ),
      ),
    );
    when(mockTopRatedMovieCubit.state).thenReturn(
      TopRatedMovieState(
        topRatedMovies: ViewData.error(failure: ServerFailure(errorMessage)),
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump();

    final textFinder = find.byKey(Key('error_message'));

    // assert
    expect(textFinder, findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
