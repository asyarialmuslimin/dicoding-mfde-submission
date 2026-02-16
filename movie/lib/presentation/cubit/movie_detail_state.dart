part of 'movie_detail_cubit.dart';

class MovieDetailState extends Equatable {
  final ViewData<MovieDetail> movieDetail;
  final ViewData<List<MovieEntity>> recommendations;
  final ViewData<bool> watchlistStatus;
  final ViewData<String> watchlistMessage;

  const MovieDetailState({
    required this.movieDetail,
    required this.recommendations,
    required this.watchlistStatus,
    required this.watchlistMessage,
  });

  MovieDetailState copyWith({
    ViewData<MovieDetail>? movieDetail,
    ViewData<List<MovieEntity>>? recommendations,
    ViewData<bool>? watchlistStatus,
    ViewData<String>? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      recommendations: recommendations ?? this.recommendations,
      watchlistStatus: watchlistStatus ?? this.watchlistStatus,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
    movieDetail,
    recommendations,
    watchlistStatus,
    watchlistMessage,
  ];
}
