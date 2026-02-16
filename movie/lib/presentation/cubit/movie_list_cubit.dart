import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  MovieListCubit({
    required GetNowPlayingMovies getNowPlayingMovies,
    required GetPopularMovies getPopularMovies,
    required GetTopRatedMovies getTopRatedMovies,
  }) : _getNowPlayingMovies = getNowPlayingMovies,
       _getPopularMovies = getPopularMovies,
       _getTopRatedMovies = getTopRatedMovies,
       super(
         MovieListState(
           nowPlayingMovies: ViewData.initial(),
           popularMovies: ViewData.initial(),
           topRatedMovies: ViewData.initial(),
         ),
       );

  void onGetNowPlayingMovie() async {
    emit(state.copyWith(nowPlayingMovies: ViewData.loading()));

    final result = await _getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(nowPlayingMovies: ViewData.error(failure: failure)),
      ),
      (movies) {
        if (movies.isNotEmpty) {
          emit(state.copyWith(nowPlayingMovies: ViewData.loaded(data: movies)));
        } else {
          emit(state.copyWith(nowPlayingMovies: ViewData.noData()));
        }
      },
    );
  }

  void onGetPopularMovie() async {
    emit(state.copyWith(popularMovies: ViewData.loading()));

    final result = await _getPopularMovies.execute();
    result.fold(
      (failure) =>
          emit(state.copyWith(popularMovies: ViewData.error(failure: failure))),
      (movies) {
        if (movies.isNotEmpty) {
          emit(state.copyWith(popularMovies: ViewData.loaded(data: movies)));
        } else {
          emit(state.copyWith(popularMovies: ViewData.noData()));
        }
      },
    );
  }

  void onGetTopRatedMovie() async {
    emit(state.copyWith(topRatedMovies: ViewData.loading()));

    final result = await _getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(topRatedMovies: ViewData.error(failure: failure)),
      ),
      (movies) {
        if (movies.isNotEmpty) {
          emit(state.copyWith(topRatedMovies: ViewData.loaded(data: movies)));
        } else {
          emit(state.copyWith(topRatedMovies: ViewData.noData()));
        }
      },
    );
  }
}
