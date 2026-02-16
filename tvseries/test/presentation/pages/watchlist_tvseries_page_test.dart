import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'watchlist_tvseries_page_test.mocks.dart';

@GenerateMocks([WatchlistTvseriesCubit])
void main() {
  late MockWatchlistTvseriesCubit mockWatchlistTvseriesCubit;

  setUp(() {
    mockWatchlistTvseriesCubit = MockWatchlistTvseriesCubit();
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
    name: 'Name',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeries];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvseriesCubit>.value(
      value: mockWatchlistTvseriesCubit,
      child: MaterialApp(home: body),
    );
  }

  group('WatchlistTVSeriesPage', () {
    testWidgets('should display loading indicator when loading', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockWatchlistTvseriesCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvseriesState(watchlistTvSeries: ViewData.loading()),
        ),
      );
      when(mockWatchlistTvseriesCubit.state).thenReturn(
        WatchlistTvseriesState(watchlistTvSeries: ViewData.loading()),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistTVSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display list of tv series when data is loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockWatchlistTvseriesCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvseriesState(
            watchlistTvSeries: ViewData.loaded(data: tTvSeriesList),
          ),
        ),
      );
      when(mockWatchlistTvseriesCubit.state).thenReturn(
        WatchlistTvseriesState(
          watchlistTvSeries: ViewData.loaded(data: tTvSeriesList),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistTVSeriesPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TVSeriesCard), findsOneWidget);
    });

    testWidgets('should display error message when error occurs', (
      WidgetTester tester,
    ) async {
      // arrange
      const errorMessage = 'Failed to load watchlist';

      when(mockWatchlistTvseriesCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvseriesState(
            watchlistTvSeries: ViewData.error(
              failure: DatabaseFailure(errorMessage),
            ),
          ),
        ),
      );
      when(mockWatchlistTvseriesCubit.state).thenReturn(
        WatchlistTvseriesState(
          watchlistTvSeries: ViewData.error(
            failure: DatabaseFailure(errorMessage),
          ),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistTVSeriesPage()));

      // assert
      expect(find.byKey(Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should trigger fetch event when page is first loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockWatchlistTvseriesCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvseriesState(
            watchlistTvSeries: ViewData.loaded(data: tTvSeriesList),
          ),
        ),
      );
      when(mockWatchlistTvseriesCubit.state).thenReturn(
        WatchlistTvseriesState(
          watchlistTvSeries: ViewData.loaded(data: tTvSeriesList),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistTVSeriesPage()));
      await tester.pump();

      // assert
      verify(mockWatchlistTvseriesCubit.fetchWatchlistTvseries()).called(1);
    });

    testWidgets('should display correct number of tv series in watchlist', (
      WidgetTester tester,
    ) async {
      // arrange
      final tMultipleTvSeries = <TvSeriesEntity>[
        tTvSeries,
        TvSeriesEntity(
          adult: false,
          backdropPath: '/path2.jpg',
          genreIds: [2],
          id: 2,
          originCountry: ['US'],
          originalLanguage: 'en',
          originalName: 'Original Name 2',
          overview: 'Overview 2',
          popularity: 2.0,
          posterPath: '/path2.jpg',
          firstAirDate: '2021-01-01',
          name: 'Name 2',
          voteAverage: 9.0,
          voteCount: 200,
        ),
      ];

      when(mockWatchlistTvseriesCubit.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvseriesState(
            watchlistTvSeries: ViewData.loaded(data: tMultipleTvSeries),
          ),
        ),
      );
      when(mockWatchlistTvseriesCubit.state).thenReturn(
        WatchlistTvseriesState(
          watchlistTvSeries: ViewData.loaded(data: tMultipleTvSeries),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(WatchlistTVSeriesPage()));

      // assert
      expect(find.byType(TVSeriesCard), findsNWidgets(2));
    });
  });
}
