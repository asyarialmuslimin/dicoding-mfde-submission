import 'package:movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

part 'top_rated_movie_state.dart';

class TopRatedMovieCubit extends Cubit<TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieCubit({required GetTopRatedMovies getTopRatedMovies})
    : _getTopRatedMovies = getTopRatedMovies,
      super(TopRatedMovieState(topRatedMovies: ViewData.initial()));

  void onGetTopRatedMovie() async {
    emit(state.copyWith(topRatedMovies: ViewData.loading()));

    final result = await _getTopRatedMovies.execute();

    result.fold(
      (failure) => emit(
        state.copyWith(topRatedMovies: ViewData.error(failure: failure)),
      ),
      (movies) =>
          emit(state.copyWith(topRatedMovies: ViewData.loaded(data: movies))),
    );
  }
}
