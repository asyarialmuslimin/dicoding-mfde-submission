import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'home_tvseries_page_test.mocks.dart';

@GenerateMocks([TvseriesListCubit])
void main() {
  late MockTvseriesListCubit mockTvseriesListCubit;

  setUp(() {
    mockTvseriesListCubit = MockTvseriesListCubit();
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
    return BlocProvider<TvseriesListCubit>.value(
      value: mockTvseriesListCubit,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == WatchlistTVSeriesPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Watchlist Page'))),
            );
          } else if (settings.name == TVSeriesSearchPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Search Page'))),
            );
          } else if (settings.name == PopularTVSeriesPage.routeName) {
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Popular Page'))),
            );
          } else if (settings.name == TopRatedTVSeriesPage.routeName) {
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

  group('HomeTVSeriesPage', () {
    testWidgets('should display AppBar with correct title and actions', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.loading(),
            popularTvSeries: ViewData.loading(),
            topRatedTvSeries: ViewData.loading(),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.loading(),
          popularTvSeries: ViewData.loading(),
          topRatedTvSeries: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));

      // assert
      expect(find.text('Ditonton : TV Series'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display loading indicators when fetching data', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.loading(),
            popularTvSeries: ViewData.loading(),
            topRatedTvSeries: ViewData.loading(),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.loading(),
          popularTvSeries: ViewData.loading(),
          topRatedTvSeries: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should display tv series lists when data is loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.loaded(data: tTvSeriesList),
            popularTvSeries: ViewData.loaded(data: tTvSeriesList),
            topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.loaded(data: tTvSeriesList),
          popularTvSeries: ViewData.loaded(data: tTvSeriesList),
          topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));

      // assert
      expect(find.byType(TVSeriesList), findsNWidgets(3));
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('should trigger fetch events when page is initialized', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.loading(),
            popularTvSeries: ViewData.loading(),
            topRatedTvSeries: ViewData.loading(),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.loading(),
          popularTvSeries: ViewData.loading(),
          topRatedTvSeries: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));
      await tester.pump();

      // assert
      verify(mockTvseriesListCubit.fetchNowPlayingTvseries()).called(1);
      verify(mockTvseriesListCubit.fetchPopularTvseries()).called(1);
      verify(mockTvseriesListCubit.fetchTopRatedTvseries()).called(1);
    });

    testWidgets('should navigate to search page when search icon is tapped', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.loading(),
            popularTvSeries: ViewData.loading(),
            topRatedTvSeries: ViewData.loading(),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.loading(),
          popularTvSeries: ViewData.loading(),
          topRatedTvSeries: ViewData.loading(),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Search Page'), findsOneWidget);
    });

    testWidgets('should navigate to popular page when See More is tapped', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.loaded(data: tTvSeriesList),
            popularTvSeries: ViewData.loaded(data: tTvSeriesList),
            topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.loaded(data: tTvSeriesList),
          popularTvSeries: ViewData.loaded(data: tTvSeriesList),
          topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));
      await tester.tap(find.text('See More').first);
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Popular Page'), findsOneWidget);
    });

    testWidgets('should display Failed text when error occurs', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockTvseriesListCubit.stream).thenAnswer(
        (_) => Stream.value(
          TvseriesListState(
            nowPlayingTvSeries: ViewData.error(
              failure: ServerFailure('Failed'),
            ),
            popularTvSeries: ViewData.error(failure: ServerFailure('Failed')),
            topRatedTvSeries: ViewData.error(failure: ServerFailure('Failed')),
          ),
        ),
      );
      when(mockTvseriesListCubit.state).thenReturn(
        TvseriesListState(
          nowPlayingTvSeries: ViewData.error(failure: ServerFailure('Failed')),
          popularTvSeries: ViewData.error(failure: ServerFailure('Failed')),
          topRatedTvSeries: ViewData.error(failure: ServerFailure('Failed')),
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(HomeTVSeriesPage()));

      // assert
      expect(find.text('Failed'), findsNWidgets(3));
    });
  });
}
