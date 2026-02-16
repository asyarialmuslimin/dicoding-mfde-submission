import 'dart:async';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:rxdart/rxdart.dart';

part 'movie_search_state.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {
  final SearchMovies usecase;

  final _querySubject = BehaviorSubject<String>();
  StreamSubscription? _querySubscription;

  MovieSearchCubit({required this.usecase})
    : super(MovieSearchState(searchResult: ViewData.initial())) {
    _querySubscription = _querySubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen(_searchMovies);
  }

  void onQueryChanged(String query) {
    if (query.isEmpty) {
      emit(MovieSearchState(searchResult: ViewData.noData()));
      return;
    }
    emit(MovieSearchState(searchResult: ViewData.loading()));

    _querySubject.add(query);
  }

  void _searchMovies(String query) async {
    if (query.isEmpty) {
      emit(MovieSearchState(searchResult: ViewData.noData()));
      return;
    }

    emit(MovieSearchState(searchResult: ViewData.loading()));

    final result = await usecase.execute(query);
    result.fold(
      (failure) => emit(
        MovieSearchState(searchResult: ViewData.error(failure: failure)),
      ),
      (movies) =>
          emit(MovieSearchState(searchResult: ViewData.loaded(data: movies))),
    );
  }

  @override
  Future<void> close() {
    _querySubscription?.cancel();
    _querySubject.close();
    return super.close();
  }
}
