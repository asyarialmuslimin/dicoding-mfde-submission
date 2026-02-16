part of 'movie_search_cubit.dart';

class MovieSearchState extends Equatable {
  final ViewData<List<MovieEntity>> searchResult;
  const MovieSearchState({required this.searchResult});

  MovieSearchState copyWith({ViewData<List<MovieEntity>>? searchResult}) {
    return MovieSearchState(searchResult: searchResult ?? this.searchResult);
  }

  @override
  List<Object> get props => [searchResult];
}
