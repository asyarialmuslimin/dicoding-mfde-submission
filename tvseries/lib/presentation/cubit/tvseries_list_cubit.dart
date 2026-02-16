import 'package:equatable/equatable.dart';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';

part 'tvseries_list_state.dart';

class TvseriesListCubit extends Cubit<TvseriesListState> {
  final GetNowPlayingTVSeries _getNowPlayingTVSeries;
  final GetPopularTVSeries _getPopularTVSeries;
  final GetTopRatedTVSeries _getTopRatedTVSeries;
  TvseriesListCubit({
    required GetNowPlayingTVSeries getNowPlayingTVSeries,
    required GetPopularTVSeries getPopularTvSeries,
    required GetTopRatedTVSeries getTopRatedTvSeries,
  }) : _getNowPlayingTVSeries = getNowPlayingTVSeries,
       _getPopularTVSeries = getPopularTvSeries,
       _getTopRatedTVSeries = getTopRatedTvSeries,
       super(
         TvseriesListState(
           nowPlayingTvSeries: ViewData.initial(),
           popularTvSeries: ViewData.initial(),
           topRatedTvSeries: ViewData.initial(),
         ),
       );

  Future<void> fetchNowPlayingTvseries() async {
    emit(state.copyWith(nowPlayingTvSeries: ViewData.loading()));

    final result = await _getNowPlayingTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(nowPlayingTvSeries: ViewData.error(failure: failure)),
      ),
      (tvSeries) {
        emit(
          state.copyWith(
            nowPlayingTvSeries: tvSeries.isNotEmpty
                ? ViewData.loaded(data: tvSeries)
                : ViewData.noData(),
          ),
        );
      },
    );
  }

  Future<void> fetchPopularTvseries() async {
    emit(state.copyWith(popularTvSeries: ViewData.loading()));

    final result = await _getPopularTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(popularTvSeries: ViewData.error(failure: failure)),
      ),
      (tvSeries) {
        emit(
          state.copyWith(
            popularTvSeries: tvSeries.isNotEmpty
                ? ViewData.loaded(data: tvSeries)
                : ViewData.noData(),
          ),
        );
      },
    );
  }

  Future<void> fetchTopRatedTvseries() async {
    emit(state.copyWith(topRatedTvSeries: ViewData.loading()));

    final result = await _getTopRatedTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(topRatedTvSeries: ViewData.error(failure: failure)),
      ),
      (tvSeries) {
        emit(
          state.copyWith(
            topRatedTvSeries: tvSeries.isNotEmpty
                ? ViewData.loaded(data: tvSeries)
                : ViewData.noData(),
          ),
        );
      },
    );
  }
}
