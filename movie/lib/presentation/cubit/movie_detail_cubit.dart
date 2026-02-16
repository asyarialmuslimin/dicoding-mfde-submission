import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:core/core.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchlistStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailCubit({
    required GetMovieDetail getMovieDetail,
    required GetMovieRecommendations getMovieRecommendations,
    required GetWatchListStatus getWatchlistStatus,
    required SaveWatchlist saveWatchlist,
    required RemoveWatchlist removeWatchlist,
  }) : _getMovieDetail = getMovieDetail,
       _getMovieRecommendations = getMovieRecommendations,
       _getWatchlistStatus = getWatchlistStatus,
       _saveWatchlist = saveWatchlist,
       _removeWatchlist = removeWatchlist,
       super(
         MovieDetailState(
           movieDetail: ViewData.initial(),
           recommendations: ViewData.initial(),
           watchlistStatus: ViewData.initial(),
           watchlistMessage: ViewData.initial(),
         ),
       );

  void onGetMovieDetail(int id) async {
    emit(state.copyWith(movieDetail: ViewData.loading()));

    final result = await _getMovieDetail.execute(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(movieDetail: ViewData.error(failure: failure))),
      (movie) {
        emit(state.copyWith(movieDetail: ViewData.loaded(data: movie)));
      },
    );
  }

  void onGetMovieRecommendations(int id) async {
    emit(state.copyWith(recommendations: ViewData.loading()));

    final result = await _getMovieRecommendations.execute(id);
    result.fold(
      (failure) => emit(
        state.copyWith(recommendations: ViewData.error(failure: failure)),
      ),
      (recomendations) {
        emit(
          state.copyWith(
            recommendations: recomendations.isNotEmpty
                ? ViewData.loaded(data: recomendations)
                : ViewData.noData(),
          ),
        );
      },
    );
  }

  void onGetMovieWatchlistStatus(int id) async {
    emit(state.copyWith(watchlistStatus: ViewData.loading()));

    final result = await _getWatchlistStatus.execute(id);
    emit(state.copyWith(watchlistStatus: ViewData.loaded(data: result)));
  }

  Future<void> onMovieAddToWatchlist(MovieDetail movie) async {
    final result = await _saveWatchlist.execute(movie);
    result.fold(
      (failure) {
        emit(
          state.copyWith(watchlistMessage: ViewData.error(failure: failure)),
        );
      },
      (message) {
        emit(
          state.copyWith(
            watchlistStatus: ViewData.loaded(data: true),
            watchlistMessage: ViewData.loaded(data: message),
          ),
        );
      },
    );
  }

  void onMovieRemoveFromWatchlist(MovieDetail movie) async {
    final result = await _removeWatchlist.execute(movie);
    result.fold(
      (failure) => emit(
        state.copyWith(watchlistStatus: ViewData.error(failure: failure)),
      ),
      (message) {
        emit(
          state.copyWith(
            watchlistStatus: ViewData.loaded(data: false),
            watchlistMessage: ViewData.loaded(data: message),
          ),
        );
      },
    );
  }
}
