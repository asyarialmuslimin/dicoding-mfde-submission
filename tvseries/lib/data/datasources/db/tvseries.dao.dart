import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

abstract class TVSeriesDao {
  Future<TVSeriesTable?> getTVSeriesById(int id);
  Future<int> insertTVSeries(TVSeriesTable tvSeries);
  Future<int> updateTVSeries(TVSeriesTable tvSeries);
  Future<int> deleteTVSeries(TVSeriesTable tvSeries);
  Future<List<TVSeriesTable>> getAllTVSeries();
}

class TvseriesDaoImpl implements TVSeriesDao {
  final DatabaseHelper databaseHelper;

  TvseriesDaoImpl({required this.databaseHelper});

  @override
  Future<TVSeriesTable?> getTVSeriesById(int id) async {
    final db = await databaseHelper.database;
    final maps = await db!.query(
      TABLE_WATCHLIST_TV_SERIES,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TVSeriesTable.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> insertTVSeries(TVSeriesTable tvSeries) async {
    final db = await databaseHelper.database;
    return await db!.insert(TABLE_WATCHLIST_TV_SERIES, tvSeries.toJson());
  }

  @override
  Future<int> updateTVSeries(TVSeriesTable tvSeries) async {
    final db = await databaseHelper.database;
    return await db!.update(
      TABLE_WATCHLIST_TV_SERIES,
      tvSeries.toJson(),
      where: 'id = ?',
      whereArgs: [tvSeries.id],
    );
  }

  @override
  Future<int> deleteTVSeries(TVSeriesTable tvSeries) async {
    final db = await databaseHelper.database;
    return await db!.delete(
      TABLE_WATCHLIST_TV_SERIES,
      where: 'id = ?',
      whereArgs: [tvSeries.id],
    );
  }

  @override
  Future<List<TVSeriesTable>> getAllTVSeries() async {
    final db = await databaseHelper.database;
    final maps = await db!.query(TABLE_WATCHLIST_TV_SERIES);
    return List<TVSeriesTable>.from(
      maps.map((map) => TVSeriesTable.fromMap(map)),
    );
  }
}
