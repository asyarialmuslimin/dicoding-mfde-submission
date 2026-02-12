import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tvseries_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        TVSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save tvseries watchlist', () {
    test("should return success message when insert to database is success",
        () async {
      when(mockDatabaseHelper.insertWatchlistTVSeries(testTVSeriesTable))
          .thenAnswer((_) async => 1);
      final result = await dataSource.insertWatchlist(testTVSeriesTable);
      expect(result, "Added to Watchlist");
    });

    test("should throw DatabaseException when insert to database is failed",
        () async {
      when(mockDatabaseHelper.insertWatchlistTVSeries(testTVSeriesTable))
          .thenThrow(Exception());
      final call = dataSource.insertWatchlist(testTVSeriesTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("remove watchlist", () {
    test("should return success message when remove from database is success",
        () async {
      when(mockDatabaseHelper.removeWatchlistTVSeries(testTVSeriesTable))
          .thenAnswer((_) async => 1);
      final result = await dataSource.removeWatchlist(testTVSeriesTable);
      expect(result, "Removed from Watchlist");
    });

    test("should throw DatabaseException when remove from database is failed",
        () async {
      when(mockDatabaseHelper.removeWatchlistTVSeries(testTVSeriesTable))
          .thenThrow(Exception());
      final call = dataSource.removeWatchlist(testTVSeriesTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("Get TVSeries Detail By Id", () {
    final tId = 1;

    test("should return TVSeries Detail Table when data is found", () async {
      when(mockDatabaseHelper.getTVSeriesById(tId))
          .thenAnswer((_) async => testTVSeriesMap);
      final result = await dataSource.getTVSeriesById(tId);
      expect(result, testTVSeriesTable);
    });

    test("should return null when data is not found", () async {
      when(mockDatabaseHelper.getTVSeriesById(tId))
          .thenAnswer((_) async => null);
      final result = await dataSource.getTVSeriesById(tId);
      expect(result, null);
    });
  });

  group("get watchlist tvseries", () {
    test("should return list of TVSeriesTable from database", () async {
      when(mockDatabaseHelper.getWatchlistTVSeries())
          .thenAnswer((_) async => [testTVSeriesMap]);
      final result = await dataSource.getWatchlistTVSeries();
      expect(result, [testTVSeriesTable]);
    });
  });
}
