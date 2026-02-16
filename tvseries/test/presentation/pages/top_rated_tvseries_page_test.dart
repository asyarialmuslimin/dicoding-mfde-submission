import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'top_rated_tvseries_page_test.mocks.dart';

@GenerateMocks([TopRatedTvseriesCubit])
void main() {
  late MockTopRatedTvseriesCubit mockTopRatedTvseriesCubit;

  setUp(() {
    mockTopRatedTvseriesCubit = MockTopRatedTvseriesCubit();
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
    return BlocProvider<TopRatedTvseriesCubit>.value(
      value: mockTopRatedTvseriesCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    // arrange
    when(mockTopRatedTvseriesCubit.stream).thenAnswer(
      (_) => Stream.value(
        TopRatedTvseriesState(topRatedTvSeries: ViewData.loading()),
      ),
    );
    when(
      mockTopRatedTvseriesCubit.state,
    ).thenReturn(TopRatedTvseriesState(topRatedTvSeries: ViewData.loading()));

    // act
    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));
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
    when(mockTopRatedTvseriesCubit.stream).thenAnswer(
      (_) => Stream.value(
        TopRatedTvseriesState(
          topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
        ),
      ),
    );
    when(mockTopRatedTvseriesCubit.state).thenReturn(
      TopRatedTvseriesState(
        topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));
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

    when(mockTopRatedTvseriesCubit.stream).thenAnswer(
      (_) => Stream.value(
        TopRatedTvseriesState(
          topRatedTvSeries: ViewData.error(
            failure: ServerFailure(errorMessage),
          ),
        ),
      ),
    );
    when(mockTopRatedTvseriesCubit.state).thenReturn(
      TopRatedTvseriesState(
        topRatedTvSeries: ViewData.error(failure: ServerFailure(errorMessage)),
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));
    await tester.pump();

    final textFinder = find.byKey(Key('error_message'));

    // assert
    expect(textFinder, findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
