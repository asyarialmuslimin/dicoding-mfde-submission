part of 'popular_tvseries_cubit.dart';

class PopularTvseriesState extends Equatable {
  final ViewData<List<TvSeriesEntity>> popularTvSeries;
  const PopularTvseriesState({required this.popularTvSeries});

  PopularTvseriesState copyWith({
    ViewData<List<TvSeriesEntity>>? popularTvSeries,
  }) {
    return PopularTvseriesState(
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
    );
  }

  @override
  List<Object> get props => [popularTvSeries];
}
