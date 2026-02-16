import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

part 'tvseries_detail_state.dart';

class TvseriesDetailCubit extends Cubit<TvseriesDetailState> {
  final GetTVSeriesDetail getTvSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchlistTVSeriesStatus getWatchlistStatus;
  final SaveWatchlistTVSeries saveWatchlist;
  final RemoveWatchlistTVSeries removeWatchlist;

  TvseriesDetailCubit({
    required this.getTvSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(
         TvseriesDetailState(
           tvSeriesDetail: ViewData.initial(),
           tvSeriesRecommendations: ViewData.initial(),
           tvSeriesWishlistStatus: ViewData.initial(),
           tvSeriesWatchlistMessage: ViewData.initial(),
         ),
       );

  Future<void> fetchTvseriesDetail(int id) async {
    emit(state.copyWith(tvSeriesDetail: ViewData.loading()));
    final result = await getTvSeriesDetail.execute(id);
    result.fold(
      (failure) => emit(
        state.copyWith(tvSeriesDetail: ViewData.error(failure: failure)),
      ),
      (tvSeries) =>
          emit(state.copyWith(tvSeriesDetail: ViewData.loaded(data: tvSeries))),
    );
  }

  Future<void> fetchTvseriesDetailRecommendations(int id) async {
    emit(state.copyWith(tvSeriesRecommendations: ViewData.loading()));
    final result = await getTVSeriesRecommendations.execute(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          tvSeriesRecommendations: ViewData.error(failure: failure),
        ),
      ),
      (tvSeries) => emit(
        state.copyWith(
          tvSeriesRecommendations: tvSeries.isNotEmpty
              ? ViewData.loaded(data: tvSeries)
              : ViewData.noData(),
        ),
      ),
    );
  }

  Future<void> getTvseriesWatchlistStatus(int id) async {
    final result = await getWatchlistStatus.execute(id);
    emit(state.copyWith(tvSeriesWishlistStatus: ViewData.loaded(data: result)));
  }

  Future<void> saveTvseriesWatchlist(TvSeriesDetail tvSeriesDetail) async {
    emit(state.copyWith(tvSeriesWatchlistMessage: ViewData.loading()));
    final result = await saveWatchlist.execute(tvSeriesDetail);
    result.fold(
      (failure) => emit(
        state.copyWith(
          tvSeriesWatchlistMessage: ViewData.error(failure: failure),
        ),
      ),
      (message) => emit(
        state.copyWith(
          tvSeriesWatchlistMessage: ViewData.loaded(data: message),
          tvSeriesWishlistStatus: ViewData.loaded(data: true),
        ),
      ),
    );
  }

  Future<void> removeTvseriesWatchlist(TvSeriesDetail tvSeriesDetail) async {
    emit(state.copyWith(tvSeriesWatchlistMessage: ViewData.loading()));
    final result = await removeWatchlist.execute(tvSeriesDetail);
    result.fold(
      (failure) => emit(
        state.copyWith(
          tvSeriesWatchlistMessage: ViewData.error(failure: failure),
        ),
      ),
      (message) => emit(
        state.copyWith(
          tvSeriesWatchlistMessage: ViewData.loaded(data: message),
          tvSeriesWishlistStatus: ViewData.loaded(data: false),
        ),
      ),
    );
  }
}
