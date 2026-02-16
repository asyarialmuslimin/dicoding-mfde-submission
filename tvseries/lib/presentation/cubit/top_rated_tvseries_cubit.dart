import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

part 'top_rated_tvseries_state.dart';

class TopRatedTvseriesCubit extends Cubit<TopRatedTvseriesState> {
  final GetTopRatedTVSeries getTopRatedTVSeries;

  TopRatedTvseriesCubit({required this.getTopRatedTVSeries})
    : super(TopRatedTvseriesState(topRatedTvSeries: ViewData.initial()));

  Future<void> fetchTopRatedTvseries() async {
    emit(TopRatedTvseriesState(topRatedTvSeries: ViewData.loading()));
    final result = await getTopRatedTVSeries.execute();
    result.fold(
      (failure) => emit(
        TopRatedTvseriesState(
          topRatedTvSeries: ViewData.error(failure: failure),
        ),
      ),
      (tvSeries) => emit(
        TopRatedTvseriesState(
          topRatedTvSeries: ViewData.loaded(data: tvSeries),
        ),
      ),
    );
  }
}
