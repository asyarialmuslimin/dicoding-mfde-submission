part of 'popular_movie_cubit.dart';

class PopularMovieState extends Equatable {
  final ViewData<List<MovieEntity>> popularMovies;
  const PopularMovieState({required this.popularMovies});

  PopularMovieState copyWith({ViewData<List<MovieEntity>>? popularMovies}) {
    return PopularMovieState(
      popularMovies: popularMovies ?? this.popularMovies,
    );
  }

  @override
  List<Object> get props => [popularMovies];
}
