import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';

abstract class TVSeriesRepository {
  Future<Either<Failure, List<TvSeriesEntity>>> getNowPlayingTVSeries();
  Future<Either<Failure, List<TvSeriesEntity>>> getPopularTVSeries();
  Future<Either<Failure, List<TvSeriesEntity>>> getTopRatedTVSeries();
  Future<Either<Failure, TvSeriesDetail>> getTVSeriesDetail(int id);
  Future<Either<Failure, List<TvSeriesEntity>>> getTVSeriesRecommendations(
    int id,
  );
  Future<Either<Failure, List<TvSeriesEntity>>> searchTVSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvSeriesDetail tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvSeriesEntity>>> getWatchlistTVSeries();
}
