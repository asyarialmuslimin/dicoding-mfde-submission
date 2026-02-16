import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  final tMovie = MovieEntity(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
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
  );

  final tMovieWithNullFields = MovieEntity(
    adult: false,
    backdropPath: null,
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: null,
    popularity: 1.0,
    posterPath: null,
    releaseDate: '2020-01-01',
    title: null,
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: Center(child: Text('Movie Detail Page'))),
          );
        }
        return null;
      },
    );
  }

  group('MovieCard Widget', () {
    testWidgets('should display movie title and overview', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      // assert
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('should display dash (-) when title and overview are null', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(MovieCard(tMovieWithNullFields)),
      );

      // assert
      expect(find.text('-'), findsNWidgets(2));
    });

    testWidgets('should have InkWell and Card widget', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

      // assert
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should navigate to MovieDetailPage when tapped', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Movie Detail Page'), findsOneWidget);
    });

    testWidgets('should pass correct movie id when navigating', (
      WidgetTester tester,
    ) async {
      int? receivedId;

      final widget = MaterialApp(
        home: Scaffold(body: MovieCard(tMovie)),
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.routeName) {
            receivedId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Movie Detail Page'))),
            );
          }
          return null;
        },
      );

      // act
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // assert
      expect(receivedId, tMovie.id);
    });
  });
}
