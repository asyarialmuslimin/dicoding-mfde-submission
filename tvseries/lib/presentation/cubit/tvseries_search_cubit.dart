import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';
import 'package:rxdart/rxdart.dart';

part 'tvseries_search_state.dart';

class TvseriesSearchCubit extends Cubit<TvseriesSearchState> {
  final SearchTVSeries searchTVSeries;

  final _querySubject = BehaviorSubject<String>();
  StreamSubscription? _querySubscription;

  TvseriesSearchCubit({required this.searchTVSeries})
    : super(TvseriesSearchState(searchResult: ViewData.initial())) {
    _querySubscription = _querySubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen(_searchTvSeries);
  }

  void onQueryChanged(String query) {
    if (query.isEmpty) {
      emit(TvseriesSearchState(searchResult: ViewData.noData()));
      return;
    }
    emit(TvseriesSearchState(searchResult: ViewData.loading()));

    _querySubject.add(query);
  }

  Future<void> _searchTvSeries(String query) async {
    emit(state.copyWith(searchResult: ViewData.loading()));
    final result = await searchTVSeries.execute(query);
    result.fold(
      (failure) =>
          emit(state.copyWith(searchResult: ViewData.error(failure: failure))),
      (tvSeries) => emit(
        state.copyWith(
          searchResult: tvSeries.isNotEmpty
              ? ViewData.loaded(data: tvSeries)
              : ViewData.noData(),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _querySubscription?.cancel();
    _querySubject.close();
    return super.close();
  }
}
