import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailCubit])
void main() {
  late MockMovieDetailCubit mockMovieDetailBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailCubit();
  });

  // Dummy data
  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-01-01',
    runtime: 120,
    title: 'Title',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieRecommendations = <MovieEntity>[
    MovieEntity(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: [1],
      id: 2,
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
    return BlocProvider<MovieDetailCubit>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(home: TickerMode(enabled: false, child: body)),
    );
  }

  group('Watchlist Button Tests', () {
    testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
        // arrange
        when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(
            MovieDetailState(
              movieDetail: ViewData.loaded(data: tMovieDetail),
              recommendations: ViewData.loaded(data: tMovieRecommendations),
              watchlistStatus: ViewData.loaded(data: false),
              watchlistMessage: ViewData.initial(),
            ),
          ),
        );
        when(mockMovieDetailBloc.state).thenReturn(
          MovieDetailState(
            movieDetail: ViewData.loaded(data: tMovieDetail),
            recommendations: ViewData.loaded(data: tMovieRecommendations),
            watchlistStatus: ViewData.loaded(data: false),
            watchlistMessage: ViewData.initial(),
          ),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
        await tester.pump();

        // assert
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      },
    );

    testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
        // arrange
        when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(
            MovieDetailState(
              movieDetail: ViewData.loaded(data: tMovieDetail),
              recommendations: ViewData.loaded(data: tMovieRecommendations),
              watchlistStatus: ViewData.loaded(data: true),
              watchlistMessage: ViewData.initial(),
            ),
          ),
        );
        when(mockMovieDetailBloc.state).thenReturn(
          MovieDetailState(
            movieDetail: ViewData.loaded(data: tMovieDetail),
            recommendations: ViewData.loaded(data: tMovieRecommendations),
            watchlistStatus: ViewData.loaded(data: true),
            watchlistMessage: ViewData.initial(),
          ),
        );

        // act
        await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
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
        final initialState = MovieDetailState(
          movieDetail: ViewData.loaded(data: tMovieDetail),
          recommendations: ViewData.loaded(data: tMovieRecommendations),
          watchlistStatus: ViewData.loaded(data: false),
          watchlistMessage: ViewData.initial(),
        );

        final successState = MovieDetailState(
          movieDetail: ViewData.loaded(data: tMovieDetail),
          recommendations: ViewData.loaded(data: tMovieRecommendations),
          watchlistStatus: ViewData.loaded(data: true),
          watchlistMessage: ViewData.loaded(data: watchlistAddSuccessMessage),
        );

        when(mockMovieDetailBloc.state).thenReturn(initialState);
        when(
          mockMovieDetailBloc.stream,
        ).thenAnswer((_) => Stream.value(successState));

        // act
        await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
        await tester.pump();

        expect(find.byIcon(Icons.check), findsOneWidget);

        // Trigger state change
        when(mockMovieDetailBloc.state).thenReturn(successState);

        await tester.tap(find.byType(FilledButton));
        await tester.pump(); // Process the tap

        // assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(watchlistAddSuccessMessage), findsOneWidget);
      },
    );

    testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist status is failed',
      (WidgetTester tester) async {
        // arrange
        const errorMessage = 'Failed to add watchlist';

        final initialState = MovieDetailState(
          movieDetail: ViewData.loaded(data: tMovieDetail),
          recommendations: ViewData.loaded(data: tMovieRecommendations),
          watchlistStatus: ViewData.loaded(data: false),
          watchlistMessage: ViewData.initial(),
        );

        final errorState = MovieDetailState(
          movieDetail: ViewData.loaded(data: tMovieDetail),
          recommendations: ViewData.loaded(data: tMovieRecommendations),
          watchlistStatus: ViewData.loaded(data: false),
          watchlistMessage: ViewData.error(
            failure: DatabaseFailure(errorMessage),
          ),
        );

        when(mockMovieDetailBloc.state).thenReturn(initialState);
        when(
          mockMovieDetailBloc.stream,
        ).thenAnswer((_) => Stream.value(errorState));

        // act
        await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
        await tester.pump();

        // assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      },
    );
  });
}
