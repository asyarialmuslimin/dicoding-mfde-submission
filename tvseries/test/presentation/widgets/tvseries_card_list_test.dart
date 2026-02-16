import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tvseries/tvseries.dart';

void main() {
  final tTvSeries = TvSeriesEntity(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
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

  final tTvSeriesWithNullFields = TvSeriesEntity(
    adult: false,
    backdropPath: null,
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: null,
    popularity: 1.0,
    posterPath: null,
    firstAirDate: '2020-01-01',
    name: null,
    voteAverage: 8.0,
    voteCount: 100,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == TVSeriesDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: Center(child: Text('TV Series Detail Page'))),
          );
        }
        return null;
      },
    );
  }

  group('TVSeriesCard Widget', () {
    testWidgets('should display tv series name and overview', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(tTvSeries)));

      // assert
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('should display dash (-) when name and overview are null', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(TVSeriesCard(tTvSeriesWithNullFields)),
      );

      // assert
      expect(find.text('-'), findsNWidgets(2));
    });

    testWidgets('should have InkWell and Card widget', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(tTvSeries)));

      // assert
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should navigate to TVSeriesDetailPage when tapped', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(tTvSeries)));
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('TV Series Detail Page'), findsOneWidget);
    });

    testWidgets('should pass correct tv series id when navigating', (
      WidgetTester tester,
    ) async {
      int? receivedId;

      final widget = MaterialApp(
        home: Scaffold(body: TVSeriesCard(tTvSeries)),
        onGenerateRoute: (settings) {
          if (settings.name == TVSeriesDetailPage.routeName) {
            receivedId = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('TV Series Detail Page'))),
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
      expect(receivedId, tTvSeries.id);
    });
  });
}
