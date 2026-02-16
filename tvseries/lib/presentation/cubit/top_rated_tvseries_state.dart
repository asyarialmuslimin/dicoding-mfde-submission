part of 'top_rated_tvseries_cubit.dart';

class TopRatedTvseriesState extends Equatable {
  final ViewData<List<TvSeriesEntity>> topRatedTvSeries;

  const TopRatedTvseriesState({required this.topRatedTvSeries});

  TopRatedTvseriesState copyWith({
    ViewData<List<TvSeriesEntity>>? topRatedTvSeries,
  }) {
    return TopRatedTvseriesState(
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
    );
  }

  @override
  List<Object?> get props => [topRatedTvSeries];
}
