import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tvseries/tvseries.dart';

void main() {
  final tSeasonList = [
    Season(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'First season overview',
      posterPath: '/path.jpg',
      seasonNumber: 1,
      voteAverage: 8.5,
    ),
    Season(
      airDate: '2021-01-01',
      episodeCount: 12,
      id: 2,
      name: 'Season 2',
      overview: 'Second season overview',
      posterPath: '/path2.jpg',
      seasonNumber: 2,
      voteAverage: 9.0,
    ),
  ];

  final tSeasonWithNullPoster = [
    Season(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'First season overview',
      posterPath: null,
      seasonNumber: 1,
      voteAverage: 8.5,
    ),
  ];

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: body);
  }

  group('TVSeriesSeasonListPage', () {
    testWidgets('should display season list', (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(TVSeriesSeasonListPage(listSeason: tSeasonList)),
      );

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Season 2'), findsOneWidget);
    });

    testWidgets('should display correct number of seasons', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(TVSeriesSeasonListPage(listSeason: tSeasonList)),
      );

      // assert
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Season 2'), findsOneWidget);
    });

    testWidgets('should display season details correctly', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(TVSeriesSeasonListPage(listSeason: tSeasonList)),
      );

      // assert
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('2020 • 10 Episode'), findsOneWidget);
      expect(find.text('First season overview'), findsOneWidget);
    });

    testWidgets('should display all season information', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(TVSeriesSeasonListPage(listSeason: tSeasonList)),
      );

      // assert
      expect(find.text('Season 2'), findsOneWidget);
      expect(find.text('2021 • 12 Episode'), findsOneWidget);
      expect(find.text('Second season overview'), findsOneWidget);
    });

    testWidgets('should not display image when posterPath is null', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(
          TVSeriesSeasonListPage(listSeason: tSeasonWithNullPoster),
        ),
      );

      // assert
      expect(find.byType(ClipRRect), findsNothing);
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('First season overview'), findsOneWidget);
    });

    testWidgets('should display AppBar with correct title', (
      WidgetTester tester,
    ) async {
      // act
      await tester.pumpWidget(
        makeTestableWidget(TVSeriesSeasonListPage(listSeason: tSeasonList)),
      );

      // assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Season List'), findsOneWidget);
    });
  });
}
