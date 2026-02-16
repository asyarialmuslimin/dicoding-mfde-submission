import 'package:movie/movie.dart';
import 'package:core/core.dart';

abstract class MovieDao {
  Future<int> insertWatchlist(MovieTable movie);
  Future<int> removeWatchlist(MovieTable movie);
  Future<Map<String, dynamic>?> getMovieById(int id);
  Future<List<Map<String, dynamic>>> getWatchlistMovies();
}

class MovieDaoImpl implements MovieDao {
  final DatabaseHelper databaseHelper;

  MovieDaoImpl({required this.databaseHelper});

  @override
  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await databaseHelper.database;
    return await db!.insert(tableWatchlistMovie, movie.toJson());
  }

  @override
  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await databaseHelper.database;
    return await db!.delete(
      tableWatchlistMovie,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  @override
  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await databaseHelper.database;
    final result = await db!.query(
      tableWatchlistMovie,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await databaseHelper.database;
    final result = await db!.query(tableWatchlistMovie);
    return result;
  }
}
