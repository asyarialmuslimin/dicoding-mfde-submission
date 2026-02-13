import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';

class GetWatchlistTVSeries {
  final TVSeriesRepository repository;

  GetWatchlistTVSeries(this.repository);

  Future<Either<Failure, List<TvSeriesEntity>>> execute() {
    return repository.getWatchlistTVSeries();
  }
}
