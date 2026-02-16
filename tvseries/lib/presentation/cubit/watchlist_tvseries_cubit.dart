import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

part 'watchlist_tvseries_state.dart';

class WatchlistTvseriesCubit extends Cubit<WatchlistTvseriesState> {
  final GetWatchlistTVSeries getWatchlistTVSeries;

  WatchlistTvseriesCubit({required this.getWatchlistTVSeries})
    : super(WatchlistTvseriesState(watchlistTvSeries: ViewData.initial()));

  Future<void> fetchWatchlistTvseries() async {
    emit(state.copyWith(watchlistTvSeries: ViewData.loading()));
    final result = await getWatchlistTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(watchlistTvSeries: ViewData.error(failure: failure)),
      ),
      (tvSeries) => emit(
        state.copyWith(
          watchlistTvSeries: tvSeries.isNotEmpty
              ? ViewData.loaded(data: tvSeries)
              : ViewData.noData(),
        ),
      ),
    );
  }
}
