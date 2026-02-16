import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'watchlist_tvseries_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late WatchlistTvseriesCubit bloc;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;

  final tTvSeries = TvSeriesEntity.watchlist(
    id: 1,
    name: 'Test',
    overview: 'Overview',
    posterPath: '/test.jpg',
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeries];

  setUp(() {
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    bloc = WatchlistTvseriesCubit(
      getWatchlistTVSeries: mockGetWatchlistTVSeries,
    );
  });

  test('initial state should be ViewData.initial()', () {
    expect(
      bloc.state,
      WatchlistTvseriesState(watchlistTvSeries: ViewData.initial()),
    );
  });

  blocTest<WatchlistTvseriesCubit, WatchlistTvseriesState>(
    'emit [Loading, HasData] when watchlist tv series success',
    build: () {
      when(
        mockGetWatchlistTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.fetchWatchlistTvseries(),
    expect: () => [
      WatchlistTvseriesState(watchlistTvSeries: ViewData.loading()),
      WatchlistTvseriesState(
        watchlistTvSeries: ViewData.loaded(data: tTvSeriesList),
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );

  blocTest<WatchlistTvseriesCubit, WatchlistTvseriesState>(
    'emit [Loading, NoData] when watchlist tv series returns empty',
    build: () {
      when(
        mockGetWatchlistTVSeries.execute(),
      ).thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.fetchWatchlistTvseries(),
    expect: () => [
      WatchlistTvseriesState(watchlistTvSeries: ViewData.loading()),
      WatchlistTvseriesState(watchlistTvSeries: ViewData.noData()),
    ],
    verify: (_) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );

  blocTest<WatchlistTvseriesCubit, WatchlistTvseriesState>(
    'emit [Loading, Error] when watchlist tv series failed',
    build: () {
      when(
        mockGetWatchlistTVSeries.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return bloc;
    },
    act: (bloc) => bloc.fetchWatchlistTvseries(),
    expect: () => [
      WatchlistTvseriesState(watchlistTvSeries: ViewData.loading()),
      WatchlistTvseriesState(
        watchlistTvSeries: ViewData.error(
          failure: DatabaseFailure('Database Failure'),
        ),
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );
}
