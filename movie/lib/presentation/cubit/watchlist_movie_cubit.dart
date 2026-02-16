import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:core/core.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMovieCubit({required GetWatchlistMovies getWatchlistMovies})
    : _getWatchlistMovies = getWatchlistMovies,
      super(WatchlistMovieState(watchlistMovies: ViewData.initial()));

  void onGetWatchlistMovie() async {
    emit(state.copyWith(watchlistMovies: ViewData.loading()));

    final result = await _getWatchlistMovies.execute();

    result.fold(
      (failure) => emit(
        state.copyWith(watchlistMovies: ViewData.error(failure: failure)),
      ),
      (movies) =>
          emit(state.copyWith(watchlistMovies: ViewData.loaded(data: movies))),
    );
  }
}
