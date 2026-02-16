import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tvseries/tvseries.dart';

import 'tvseries_dao_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late TvseriesDaoImpl dao;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    dao = TvseriesDaoImpl(databaseHelper: mockDatabaseHelper);
  });

  final tTvSeriesTable = TVSeriesTable(
    id: 1,
    name: 'Name',
    posterPath: '/path.jpg',
    overview: 'Overview',
  );

  final tTvSeriesMap = {
    'id': 1,
    'name': 'Name',
    'posterPath': '/path.jpg',
    'overview': 'Overview',
  };

  group('TvseriesDao', () {
    group('getTVSeriesById', () {
      test('should return tv series table when data exists', () async {
        // arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            tableWatchlistTVSeries,
            where: 'id = ?',
            whereArgs: [1],
          ),
        ).thenAnswer((_) async => [tTvSeriesMap]);

        // act
        final result = await dao.getTVSeriesById(1);

        // assert
        expect(result, equals(tTvSeriesTable));
        verify(mockDatabaseHelper.database);
        verify(
          mockDatabase.query(
            tableWatchlistTVSeries,
            where: 'id = ?',
            whereArgs: [1],
          ),
        );
      });

      test('should return null when data does not exist', () async {
        // arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            tableWatchlistTVSeries,
            where: 'id = ?',
            whereArgs: [1],
          ),
        ).thenAnswer((_) async => []);

        // act
        final result = await dao.getTVSeriesById(1);

        // assert
        expect(result, isNull);
        verify(mockDatabaseHelper.database);
      });
    });

    group('insertTVSeries', () {
      test('should return insert id when insert is successful', () async {
        // arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.insert(tableWatchlistTVSeries, tTvSeriesTable.toJson()),
        ).thenAnswer((_) async => 1);

        // act
        final result = await dao.insertTVSeries(tTvSeriesTable);

        // assert
        expect(result, 1);
        verify(mockDatabaseHelper.database);
        verify(
          mockDatabase.insert(tableWatchlistTVSeries, tTvSeriesTable.toJson()),
        );
      });
    });

    group('updateTVSeries', () {
      test(
        'should return number of rows affected when update is successful',
        () async {
          // arrange
          when(
            mockDatabaseHelper.database,
          ).thenAnswer((_) async => mockDatabase);
          when(
            mockDatabase.update(
              tableWatchlistTVSeries,
              tTvSeriesTable.toJson(),
              where: 'id = ?',
              whereArgs: [tTvSeriesTable.id],
            ),
          ).thenAnswer((_) async => 1);

          // act
          final result = await dao.updateTVSeries(tTvSeriesTable);

          // assert
          expect(result, 1);
          verify(mockDatabaseHelper.database);
          verify(
            mockDatabase.update(
              tableWatchlistTVSeries,
              tTvSeriesTable.toJson(),
              where: 'id = ?',
              whereArgs: [tTvSeriesTable.id],
            ),
          );
        },
      );
    });

    group('deleteTVSeries', () {
      test(
        'should return number of rows affected when delete is successful',
        () async {
          // arrange
          when(
            mockDatabaseHelper.database,
          ).thenAnswer((_) async => mockDatabase);
          when(
            mockDatabase.delete(
              tableWatchlistTVSeries,
              where: 'id = ?',
              whereArgs: [tTvSeriesTable.id],
            ),
          ).thenAnswer((_) async => 1);

          // act
          final result = await dao.deleteTVSeries(tTvSeriesTable);

          // assert
          expect(result, 1);
          verify(mockDatabaseHelper.database);
          verify(
            mockDatabase.delete(
              tableWatchlistTVSeries,
              where: 'id = ?',
              whereArgs: [tTvSeriesTable.id],
            ),
          );
        },
      );
    });

    group('getAllTVSeries', () {
      test('should return list of tv series tables when data exists', () async {
        // arrange
        final tTvSeriesMapList = [tTvSeriesMap];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(tableWatchlistTVSeries),
        ).thenAnswer((_) async => tTvSeriesMapList);

        // act
        final result = await dao.getAllTVSeries();

        // assert
        expect(result, equals([tTvSeriesTable]));
        verify(mockDatabaseHelper.database);
        verify(mockDatabase.query(tableWatchlistTVSeries));
      });

      test('should return empty list when no data exists', () async {
        // arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(tableWatchlistTVSeries),
        ).thenAnswer((_) async => []);

        // act
        final result = await dao.getAllTVSeries();

        // assert
        expect(result, equals([]));
        verify(mockDatabaseHelper.database);
        verify(mockDatabase.query(tableWatchlistTVSeries));
      });
    });
  });
}
