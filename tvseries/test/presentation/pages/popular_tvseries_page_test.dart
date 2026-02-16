import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'popular_tvseries_page_test.mocks.dart';

@GenerateMocks([PopularTvseriesCubit])
void main() {
  late MockPopularTvseriesCubit mockPopularTvseriesCubit;

  setUp(() {
    mockPopularTvseriesCubit = MockPopularTvseriesCubit();
  });

  final tTvSeriesList = <TvSeriesEntity>[
    TvSeriesEntity(
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
    ),
  ];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvseriesCubit>.value(
      value: mockPopularTvseriesCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    // arrange
    when(mockPopularTvseriesCubit.stream).thenAnswer(
      (_) => Stream.value(
        PopularTvseriesState(popularTvSeries: ViewData.loading()),
      ),
    );
    when(
      mockPopularTvseriesCubit.state,
    ).thenReturn(PopularTvseriesState(popularTvSeries: ViewData.loading()));

    // act
    await tester.pumpWidget(makeTestableWidget(PopularTVSeriesPage()));
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
    when(mockPopularTvseriesCubit.stream).thenAnswer(
      (_) => Stream.value(
        PopularTvseriesState(
          popularTvSeries: ViewData.loaded(data: tTvSeriesList),
        ),
      ),
    );
    when(mockPopularTvseriesCubit.state).thenReturn(
      PopularTvseriesState(
        popularTvSeries: ViewData.loaded(data: tTvSeriesList),
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(PopularTVSeriesPage()));
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

    when(mockPopularTvseriesCubit.stream).thenAnswer(
      (_) => Stream.value(
        PopularTvseriesState(
          popularTvSeries: ViewData.error(failure: ServerFailure(errorMessage)),
        ),
      ),
    );
    when(mockPopularTvseriesCubit.state).thenReturn(
      PopularTvseriesState(
        popularTvSeries: ViewData.error(failure: ServerFailure(errorMessage)),
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(PopularTVSeriesPage()));
    await tester.pump();

    final textFinder = find.byKey(Key('error_message'));

    // assert
    expect(textFinder, findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
