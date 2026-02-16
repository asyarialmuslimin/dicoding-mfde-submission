import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    // Initialize sqflite for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseHelper = DatabaseHelper();
  });

  group('DatabaseHelper', () {
    test('should be a singleton', () {
      // arrange
      final instance1 = DatabaseHelper();
      final instance2 = DatabaseHelper();

      // assert
      expect(instance1, equals(instance2));
      expect(identical(instance1, instance2), true);
    });

    test('should return database instance', () async {
      // act
      final result = await databaseHelper.database;

      // assert
      expect(result, isA<Database>());
      expect(result, isNotNull);
    });

    test(
      'should create movie watchlist table on database initialization',
      () async {
        // act
        final db = await databaseHelper.database;
        final tables = await db!.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableWatchlistMovie'",
        );

        // assert
        expect(tables.isNotEmpty, true);
        expect(tables.first['name'], tableWatchlistMovie);
      },
    );

    test(
      'should create tv series watchlist table on database initialization',
      () async {
        // act
        final db = await databaseHelper.database;
        final tables = await db!.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableWatchlistTVSeries'",
        );

        // assert
        expect(tables.isNotEmpty, true);
        expect(tables.first['name'], tableWatchlistTVSeries);
      },
    );

    test('should have correct columns in movie watchlist table', () async {
      // act
      final db = await databaseHelper.database;
      final columns = await db!.rawQuery(
        "PRAGMA table_info($tableWatchlistMovie)",
      );

      final columnNames = columns.map((col) => col['name']).toList();

      // assert
      expect(columnNames.contains('id'), true);
      expect(columnNames.contains('title'), true);
      expect(columnNames.contains('overview'), true);
      expect(columnNames.contains('posterPath'), true);
    });
  });
}
