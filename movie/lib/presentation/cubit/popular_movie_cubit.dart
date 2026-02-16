import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:core/core.dart';

part 'popular_movie_state.dart';

class PopularMovieCubit extends Cubit<PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieCubit({required GetPopularMovies getPopularMovies})
    : _getPopularMovies = getPopularMovies,
      super(PopularMovieState(popularMovies: ViewData.initial()));

  void onGetPopularMovie() async {
    emit(state.copyWith(popularMovies: ViewData.loading()));

    final result = await _getPopularMovies.execute();

    result.fold(
      (failure) =>
          emit(state.copyWith(popularMovies: ViewData.error(failure: failure))),
      (movies) =>
          emit(state.copyWith(popularMovies: ViewData.loaded(data: movies))),
    );
  }
}
