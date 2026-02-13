import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';

abstract class TVSeriesLocalDataSource {
  Future<String> insertWatchlist(TVSeriesTable tvSeries);
  Future<String> removeWatchlist(TVSeriesTable tvSeries);
  Future<TVSeriesTable?> getTVSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistTVSeries();
}

class TVSeriesLocalDataSourceImpl implements TVSeriesLocalDataSource {
  final TVSeriesDao tvSeriesDao;

  TVSeriesLocalDataSourceImpl({required this.tvSeriesDao});

  @override
  Future<TVSeriesTable?> getTVSeriesById(int id) async {
    final result = await tvSeriesDao.getTVSeriesById(id);
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistTVSeries() async {
    final result = await tvSeriesDao.getAllTVSeries();
    return result;
  }

  @override
  Future<String> insertWatchlist(TVSeriesTable tvSeries) async {
    try {
      await tvSeriesDao.insertTVSeries(tvSeries);
      return "Added to Watchlist";
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVSeriesTable tvSeries) async {
    try {
      await tvSeriesDao.deleteTVSeries(tvSeries);
      return "Removed from Watchlist";
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
