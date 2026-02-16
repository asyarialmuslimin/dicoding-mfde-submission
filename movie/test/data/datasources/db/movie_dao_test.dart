import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:sqflite/sqflite.dart';

import 'movie_dao_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late MovieDao movieDao;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    movieDao = MovieDaoImpl(databaseHelper: mockDatabaseHelper);
  });

  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  group('insertWatchlist', () {
    test('should return id when insert is successful', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabase.insert(tableWatchlistMovie, tMovieTable.toJson()),
      ).thenAnswer((_) async => 1);

      // act
      final result = await movieDao.insertWatchlist(tMovieTable);

      // assert
      expect(result, 1);
      verify(mockDatabase.insert(tableWatchlistMovie, tMovieTable.toJson()));
    });
  });

  group('removeWatchlist', () {
    test(
      'should return number of rows deleted when delete is successful',
      () async {
        // arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.delete(
            tableWatchlistMovie,
            where: 'id = ?',
            whereArgs: [tMovieTable.id],
          ),
        ).thenAnswer((_) async => 1);

        // act
        final result = await movieDao.removeWatchlist(tMovieTable);

        // assert
        expect(result, 1);
        verify(
          mockDatabase.delete(
            tableWatchlistMovie,
            where: 'id = ?',
            whereArgs: [tMovieTable.id],
          ),
        );
      },
    );
  });

  group('getMovieById', () {
    test('should return movie map when movie is found', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabase.query(
          tableWatchlistMovie,
          where: 'id = ?',
          whereArgs: [1],
        ),
      ).thenAnswer((_) async => [tMovieMap]);

      // act
      final result = await movieDao.getMovieById(1);

      // assert
      expect(result, tMovieMap);
      verify(
        mockDatabase.query(
          tableWatchlistMovie,
          where: 'id = ?',
          whereArgs: [1],
        ),
      );
    });

    test('should return null when movie is not found', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabase.query(
          tableWatchlistMovie,
          where: 'id = ?',
          whereArgs: [1],
        ),
      ).thenAnswer((_) async => []);

      // act
      final result = await movieDao.getMovieById(1);

      // assert
      expect(result, null);
      verify(
        mockDatabase.query(
          tableWatchlistMovie,
          where: 'id = ?',
          whereArgs: [1],
        ),
      );
    });
  });

  group('getWatchlistMovies', () {
    test('should return list of movie maps when query is successful', () async {
      // arrange
      final tMovieMapList = [
        tMovieMap,
        {
          'id': 2,
          'title': 'title 2',
          'posterPath': 'posterPath 2',
          'overview': 'overview 2',
        },
      ];

      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabase.query(tableWatchlistMovie),
      ).thenAnswer((_) async => tMovieMapList);

      // act
      final result = await movieDao.getWatchlistMovies();

      // assert
      expect(result, tMovieMapList);
      verify(mockDatabase.query(tableWatchlistMovie));
    });

    test('should return empty list when no movies in watchlist', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(mockDatabase.query(tableWatchlistMovie)).thenAnswer((_) async => []);

      // act
      final result = await movieDao.getWatchlistMovies();

      // assert
      expect(result, []);
      verify(mockDatabase.query(tableWatchlistMovie));
    });
  });
}
