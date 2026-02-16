part of 'tvseries_search_cubit.dart';

class TvseriesSearchState extends Equatable {
  final ViewData<List<TvSeriesEntity>> searchResult;
  const TvseriesSearchState({required this.searchResult});

  TvseriesSearchState copyWith({ViewData<List<TvSeriesEntity>>? searchResult}) {
    return TvseriesSearchState(searchResult: searchResult ?? this.searchResult);
  }

  @override
  List<Object> get props => [searchResult];
}
