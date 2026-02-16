part of 'watchlist_tvseries_cubit.dart';

class WatchlistTvseriesState extends Equatable {
  final ViewData<List<TvSeriesEntity>> watchlistTvSeries;
  const WatchlistTvseriesState({required this.watchlistTvSeries});

  WatchlistTvseriesState copyWith({
    ViewData<List<TvSeriesEntity>>? watchlistTvSeries,
  }) {
    return WatchlistTvseriesState(
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
    );
  }

  @override
  List<Object?> get props => [watchlistTvSeries];
}
