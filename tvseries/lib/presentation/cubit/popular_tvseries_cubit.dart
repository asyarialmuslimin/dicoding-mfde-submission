import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

part 'popular_tvseries_state.dart';

class PopularTvseriesCubit extends Cubit<PopularTvseriesState> {
  final GetPopularTVSeries _getPopularTVSeries;

  PopularTvseriesCubit({required GetPopularTVSeries getPopularTVSeries})
    : _getPopularTVSeries = getPopularTVSeries,
      super(PopularTvseriesState(popularTvSeries: ViewData.initial()));

  Future<void> fetchPopularTvseries() async {
    emit(state.copyWith(popularTvSeries: ViewData.loading()));
    final result = await _getPopularTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(popularTvSeries: ViewData.error(failure: failure)),
      ),
      (tvSeries) => emit(
        state.copyWith(popularTvSeries: ViewData.loaded(data: tvSeries)),
      ),
    );
  }
}
