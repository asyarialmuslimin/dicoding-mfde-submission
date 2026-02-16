import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchCubit])
void main() {
  late MockMovieSearchCubit mockMovieSearchCubit;

  setUp(() {
    mockMovieSearchCubit = MockMovieSearchCubit();
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
    title: 'Spider-Man',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieList = <MovieEntity>[tMovie];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchCubit>.value(
      value: mockMovieSearchCubit,
      child: MaterialApp(home: body),
    );
  }

  group('SearchPage', () {
    testWidgets('should display search text field', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieSearchCubit.stream).thenAnswer(
        (_) => Stream.value(MovieSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockMovieSearchCubit.state,
      ).thenReturn(MovieSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      // assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display list of movies when search has data', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieSearchCubit.stream).thenAnswer(
        (_) => Stream.value(
          MovieSearchState(searchResult: ViewData.loaded(data: tMovieList)),
        ),
      );
      when(mockMovieSearchCubit.state).thenReturn(
        MovieSearchState(searchResult: ViewData.loaded(data: tMovieList)),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsOneWidget);
    });

    testWidgets('should display empty container when search has no data', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieSearchCubit.stream).thenAnswer(
        (_) => Stream.value(MovieSearchState(searchResult: ViewData.noData())),
      );
      when(
        mockMovieSearchCubit.state,
      ).thenReturn(MovieSearchState(searchResult: ViewData.noData()));

      // act
      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      // assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should trigger search event when text field changes', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieSearchCubit.stream).thenAnswer(
        (_) => Stream.value(MovieSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockMovieSearchCubit.state,
      ).thenReturn(MovieSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      await tester.enterText(find.byType(TextField), 'spiderman');
      await tester.pump();

      // assert
      verify(mockMovieSearchCubit.onQueryChanged('spiderman')).called(1);
    });

    testWidgets('should display correct hint text in search field', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieSearchCubit.stream).thenAnswer(
        (_) => Stream.value(MovieSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockMovieSearchCubit.state,
      ).thenReturn(MovieSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      // assert
      expect(find.text('Search title'), findsOneWidget);
      expect(find.text('Search Result'), findsOneWidget);
    });

    testWidgets('should display empty container when state is initial', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockMovieSearchCubit.stream).thenAnswer(
        (_) => Stream.value(MovieSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockMovieSearchCubit.state,
      ).thenReturn(MovieSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(SearchPage()));

      // assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    });
  });
}
