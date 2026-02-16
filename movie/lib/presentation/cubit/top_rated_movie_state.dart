part of 'top_rated_movie_cubit.dart';

class TopRatedMovieState extends Equatable {
  final ViewData<List<MovieEntity>> topRatedMovies;
  const TopRatedMovieState({required this.topRatedMovies});

  TopRatedMovieState copyWith({ViewData<List<MovieEntity>>? topRatedMovies}) {
    return TopRatedMovieState(
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object> get props => [topRatedMovies];
}
