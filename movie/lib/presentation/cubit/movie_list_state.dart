part of 'movie_list_cubit.dart';

class MovieListState extends Equatable {
  final ViewData<List<MovieEntity>> nowPlayingMovies;
  final ViewData<List<MovieEntity>> popularMovies;
  final ViewData<List<MovieEntity>> topRatedMovies;

  const MovieListState({
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
  });

  MovieListState copyWith({
    ViewData<List<MovieEntity>>? nowPlayingMovies,
    ViewData<List<MovieEntity>>? popularMovies,
    ViewData<List<MovieEntity>>? topRatedMovies,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object?> get props => [nowPlayingMovies, popularMovies, topRatedMovies];
}
