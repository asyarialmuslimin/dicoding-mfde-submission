import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'tvseries_detail_page_test.mocks.dart';

@GenerateMocks([TvseriesDetailCubit])
void main() {
  late MockTvseriesDetailCubit mockTvseriesDetailCubit;

  setUp(() {
    mockTvseriesDetailCubit = MockTvseriesDetailCubit();
  });

  // Dummy data dengan seasons tidak kosong
  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [60],
    firstAirDate: '2020-01-01',
    genres: [Genre(id: 1, name: 'Drama')],
    homepage: 'https://homepage.com',
    id: 1,
    inProduction: false,
    languages: ['en'],
    lastAirDate: '2020-12-31',
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 100.0,
    posterPath: '/path.jpg',
    status: 'Ended',
    tagline: 'tagline',
    type: 'Scripted',
    voteAverage: 8.0,
    voteCount: 100,
    lastEpisodeToAir: LastEpisodeToAir(
      id: 1,
      name: 'Episode 1',
      overview: 'Overview',
      voteAverage: 8.0,
      voteCount: 100,
      airDate: '2020-01-01',
      episodeNumber: 1,
      productionCode: '',
      runtime: 60,
      seasonNumber: 1,
      showId: 1,
      stillPath: '/path.jpg',
      episodeType: "",
    ),
    seasons: [
      Season(
        airDate: '2020-01-01',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'Overview',
        posterPath: '/path.jpg',
        seasonNumber: 1,
        voteAverage: 8.0,
      ),
    ],
  );

  final tTvSeriesRecommendations = <TvSeriesEntity>[
    TvSeriesEntity(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: [1],
      id: 2,
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
    return BlocProvider<TvseriesDetailCubit>.value(
      value: mockTvseriesDetailCubit,
      child: MaterialApp(home: body),
    );
  }

  group('Watchlist Button Tests', () {
    testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
        // arrange
        when(mockTvseriesDetailCubit.stream).thenAnswer(
          (_) => Stream.value(
            TvseriesDetailState(
              tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
              tvSeriesRecommendations: ViewData.loaded(
                data: tTvSeriesRecommendations,
              ),
              tvSeriesWishlistStatus: ViewData.loaded(data: false),
              tvSeriesWatchlistMessage: ViewData.initial(),
            ),
          ),
        );
        when(mockTvseriesDetailCubit.state).thenReturn(
          TvseriesDetailState(
            tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
            tvSeriesRecommendations: ViewData.loaded(
              data: tTvSeriesRecommendations,
            ),
            tvSeriesWishlistStatus: ViewData.loaded(data: false),
            tvSeriesWatchlistMessage: ViewData.initial(),
          ),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
        await tester.pump();

        // assert
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      },
    );

    testWidgets(
      'Watchlist button should display check icon when tv series is added to watchlist',
      (WidgetTester tester) async {
        // arrange
        when(mockTvseriesDetailCubit.stream).thenAnswer(
          (_) => Stream.value(
            TvseriesDetailState(
              tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
              tvSeriesRecommendations: ViewData.loaded(
                data: tTvSeriesRecommendations,
              ),
              tvSeriesWishlistStatus: ViewData.loaded(data: true),
              tvSeriesWatchlistMessage: ViewData.initial(),
            ),
          ),
        );
        when(mockTvseriesDetailCubit.state).thenReturn(
          TvseriesDetailState(
            tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
            tvSeriesRecommendations: ViewData.loaded(
              data: tTvSeriesRecommendations,
            ),
            tvSeriesWishlistStatus: ViewData.loaded(data: true),
            tvSeriesWatchlistMessage: ViewData.initial(),
          ),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
        await tester.pump();

        // assert
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.byIcon(Icons.add), findsNothing);
      },
    );

    testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
        // arrange
        final initialState = TvseriesDetailState(
          tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
          tvSeriesRecommendations: ViewData.loaded(
            data: tTvSeriesRecommendations,
          ),
          tvSeriesWishlistStatus: ViewData.loaded(data: false),
          tvSeriesWatchlistMessage: ViewData.initial(),
        );

        final successState = TvseriesDetailState(
          tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
          tvSeriesRecommendations: ViewData.loaded(
            data: tTvSeriesRecommendations,
          ),
          tvSeriesWishlistStatus: ViewData.loaded(data: true),
          tvSeriesWatchlistMessage: ViewData.loaded(
            data: watchlistAddSuccessMessage,
          ),
        );

        when(mockTvseriesDetailCubit.state).thenReturn(initialState);
        when(
          mockTvseriesDetailCubit.stream,
        ).thenAnswer((_) => Stream.value(successState));

        // act
        await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
        await tester.pump();

        expect(find.byIcon(Icons.check), findsOneWidget);

        // Trigger state change
        when(mockTvseriesDetailCubit.state).thenReturn(successState);

        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        // assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(watchlistAddSuccessMessage), findsOneWidget);
      },
    );

    testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
        // arrange
        const errorMessage = 'Failed to add watchlist';

        final initialState = TvseriesDetailState(
          tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
          tvSeriesRecommendations: ViewData.loaded(
            data: tTvSeriesRecommendations,
          ),
          tvSeriesWishlistStatus: ViewData.loaded(data: false),
          tvSeriesWatchlistMessage: ViewData.initial(),
        );

        final errorState = TvseriesDetailState(
          tvSeriesDetail: ViewData.loaded(data: tTvSeriesDetail),
          tvSeriesRecommendations: ViewData.loaded(
            data: tTvSeriesRecommendations,
          ),
          tvSeriesWishlistStatus: ViewData.loaded(data: false),
          tvSeriesWatchlistMessage: ViewData.error(
            failure: DatabaseFailure(errorMessage),
          ),
        );

        when(mockTvseriesDetailCubit.state).thenReturn(initialState);
        when(
          mockTvseriesDetailCubit.stream,
        ).thenAnswer((_) => Stream.value(errorState));

        // act
        await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
        await tester.pump();

        // assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      },
    );
  });
}
