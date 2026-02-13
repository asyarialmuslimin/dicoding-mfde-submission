import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesLocalDataSourceImpl dataSource;
  late MockTVSeriesDao mockTVSeriesDao;

  setUp(() {
    mockTVSeriesDao = MockTVSeriesDao();
    dataSource = TVSeriesLocalDataSourceImpl(tvSeriesDao: mockTVSeriesDao);
  });

  group('save tvseries watchlist', () {
    test(
      "should return success message when insert to database is success",
      () async {
        when(
          mockTVSeriesDao.insertTVSeries(testTVSeriesTable),
        ).thenAnswer((_) async => 1);
        final result = await dataSource.insertWatchlist(testTVSeriesTable);
        expect(result, "Added to Watchlist");
      },
    );

    test(
      "should throw DatabaseException when insert to database is failed",
      () async {
        when(
          mockTVSeriesDao.insertTVSeries(testTVSeriesTable),
        ).thenThrow(Exception());
        final call = dataSource.insertWatchlist(testTVSeriesTable);
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group("remove watchlist", () {
    test(
      "should return success message when remove from database is success",
      () async {
        when(
          mockTVSeriesDao.deleteTVSeries(testTVSeriesTable),
        ).thenAnswer((_) async => 1);
        final result = await dataSource.removeWatchlist(testTVSeriesTable);
        expect(result, "Removed from Watchlist");
      },
    );

    test(
      "should throw DatabaseException when remove from database is failed",
      () async {
        when(
          mockTVSeriesDao.deleteTVSeries(testTVSeriesTable),
        ).thenThrow(Exception());
        final call = dataSource.removeWatchlist(testTVSeriesTable);
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group("Get TVSeries Detail By Id", () {
    final tId = 1;

    test("should return TVSeries Detail Table when data is found", () async {
      when(
        mockTVSeriesDao.getTVSeriesById(tId),
      ).thenAnswer((_) async => testTVSeriesTable);
      final result = await dataSource.getTVSeriesById(tId);
      expect(result, testTVSeriesTable);
    });

    test("should return null when data is not found", () async {
      when(mockTVSeriesDao.getTVSeriesById(tId)).thenAnswer((_) async => null);
      final result = await dataSource.getTVSeriesById(tId);
      expect(result, null);
    });
  });

  group("get watchlist tvseries", () {
    test("should return list of TVSeriesTable from database", () async {
      when(
        mockTVSeriesDao.getAllTVSeries(),
      ).thenAnswer((_) async => [testTVSeriesTable]);
      final result = await dataSource.getWatchlistTVSeries();
      expect(result, [testTVSeriesTable]);
    });
  });
}
