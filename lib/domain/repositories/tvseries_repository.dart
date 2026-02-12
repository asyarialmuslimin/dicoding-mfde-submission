import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';

abstract class TVSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTVSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTVSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTVSeries();
  Future<Either<Failure, TvSeriesDetail>> getTVSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTVSeriesRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTVSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvSeriesDetail tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTVSeries();
}
