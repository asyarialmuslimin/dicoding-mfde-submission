part of 'watchlist_movie_cubit.dart';

class WatchlistMovieState extends Equatable {
  final ViewData<List<MovieEntity>> watchlistMovies;
  const WatchlistMovieState({required this.watchlistMovies});

  WatchlistMovieState copyWith({ViewData<List<MovieEntity>>? watchlistMovies}) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
    );
  }

  @override
  List<Object> get props => [watchlistMovies];
}
