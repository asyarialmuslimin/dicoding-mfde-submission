part of 'tvseries_list_cubit.dart';

class TvseriesListState extends Equatable {
  final ViewData<List<TvSeriesEntity>> nowPlayingTvSeries;
  final ViewData<List<TvSeriesEntity>> popularTvSeries;
  final ViewData<List<TvSeriesEntity>> topRatedTvSeries;
  const TvseriesListState({
    required this.nowPlayingTvSeries,
    required this.popularTvSeries,
    required this.topRatedTvSeries,
  });

  TvseriesListState copyWith({
    ViewData<List<TvSeriesEntity>>? nowPlayingTvSeries,
    ViewData<List<TvSeriesEntity>>? popularTvSeries,
    ViewData<List<TvSeriesEntity>>? topRatedTvSeries,
  }) {
    return TvseriesListState(
      nowPlayingTvSeries: nowPlayingTvSeries ?? this.nowPlayingTvSeries,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
    );
  }

  @override
  List<Object> get props => [
    nowPlayingTvSeries,
    popularTvSeries,
    topRatedTvSeries,
  ];
}
