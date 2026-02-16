import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'tvseries_search_page_test.mocks.dart';

@GenerateMocks([TvseriesSearchCubit])
void main() {
  late MockTvseriesSearchCubit mockTvseriesSearchCubit;

  setUp(() {
    mockTvseriesSearchCubit = MockTvseriesSearchCubit();
  });

  final tTvSeries = TvSeriesEntity(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2020-01-01',
    name: 'Breaking Bad',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeries];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvseriesSearchCubit>.value(
      value: mockTvseriesSearchCubit,
      child: MaterialApp(home: body),
    );
  }

  group('TVSeriesSearchPage', () {
    testWidgets('should display search text field', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesSearchCubit.stream).thenAnswer(
        (_) =>
            Stream.value(TvseriesSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockTvseriesSearchCubit.state,
      ).thenReturn(TvseriesSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesSearchPage()));

      // assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display loading indicator when searching', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesSearchCubit.stream).thenAnswer(
        (_) =>
            Stream.value(TvseriesSearchState(searchResult: ViewData.loading())),
      );
      when(
        mockTvseriesSearchCubit.state,
      ).thenReturn(TvseriesSearchState(searchResult: ViewData.loading()));

      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesSearchPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display list of tv series when search has data', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesSearchCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesSearchState(
            searchResult: ViewData.loaded(data: tTvSeriesList),
          ),
        ),
      );
      when(mockTvseriesSearchCubit.state).thenReturn(
        TvseriesSearchState(searchResult: ViewData.loaded(data: tTvSeriesList)),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesSearchPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TVSeriesCard), findsOneWidget);
    });

    testWidgets('should display empty container when search has no data', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesSearchCubit.stream).thenAnswer(
        (_) =>
            Stream.value(TvseriesSearchState(searchResult: ViewData.noData())),
      );
      when(
        mockTvseriesSearchCubit.state,
      ).thenReturn(TvseriesSearchState(searchResult: ViewData.noData()));

      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesSearchPage()));

      // assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should trigger search event when text field changes', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesSearchCubit.stream).thenAnswer(
        (_) =>
            Stream.value(TvseriesSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockTvseriesSearchCubit.state,
      ).thenReturn(TvseriesSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesSearchPage()));
      await tester.enterText(find.byType(TextField), 'breaking bad');
      await tester.pump();

      // assert
      verify(mockTvseriesSearchCubit.onQueryChanged('breaking bad')).called(1);
    });

    testWidgets('should display correct hint text in search field', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesSearchCubit.stream).thenAnswer(
        (_) =>
            Stream.value(TvseriesSearchState(searchResult: ViewData.initial())),
      );
      when(
        mockTvseriesSearchCubit.state,
      ).thenReturn(TvseriesSearchState(searchResult: ViewData.initial()));

      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesSearchPage()));

      // assert
      expect(find.text('Search title'), findsOneWidget);
      expect(find.text('Search Result'), findsOneWidget);
    });
  });
}
