import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'tvseries_list_cubit_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late TvseriesListCubit tvseriesListBloc;
  late MockGetNowPlayingTVSeries mockNowPlaying;
  late MockGetPopularTVSeries mockPopular;
  late MockGetTopRatedTVSeries mockTopRated;

  setUp(() {
    mockNowPlaying = MockGetNowPlayingTVSeries();
    mockPopular = MockGetPopularTVSeries();
    mockTopRated = MockGetTopRatedTVSeries();

    tvseriesListBloc = TvseriesListCubit(
      getNowPlayingTVSeries: mockNowPlaying,
      getPopularTvSeries: mockPopular,
      getTopRatedTvSeries: mockTopRated,
    );
  });

  test('initial state should be initial ViewData', () {
    expect(
      tvseriesListBloc.state,
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
    );
  });

  final tTvSeries = TvSeriesEntity.watchlist(
    id: 1,
    name: 'Test TV Series',
    overview: 'overview',
    posterPath: '/test.jpg',
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeries];

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, HasData] when now playing success',
    build: () {
      when(
        mockNowPlaying.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchNowPlayingTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.loading(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.loaded(data: tTvSeriesList),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
    ],
    verify: (_) {
      verify(mockNowPlaying.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, NoData] when now playing returns empty',
    build: () {
      when(mockNowPlaying.execute()).thenAnswer((_) async => Right([]));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchNowPlayingTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.loading(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.noData(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
    ],
    verify: (_) {
      verify(mockNowPlaying.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, Error] when now playing fails',
    build: () {
      when(
        mockNowPlaying.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchNowPlayingTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.loading(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.error(
          failure: ServerFailure('Server Failure'),
        ),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.initial(),
      ),
    ],
    verify: (_) {
      verify(mockNowPlaying.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, HasData] when popular success',
    build: () {
      when(mockPopular.execute()).thenAnswer((_) async => Right(tTvSeriesList));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchPopularTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.loading(),
        topRatedTvSeries: ViewData.initial(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.loaded(data: tTvSeriesList),
        topRatedTvSeries: ViewData.initial(),
      ),
    ],
    verify: (_) {
      verify(mockPopular.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, NoData] when popular returns empty',
    build: () {
      when(mockPopular.execute()).thenAnswer((_) async => Right([]));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchPopularTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.loading(),
        topRatedTvSeries: ViewData.initial(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.noData(),
        topRatedTvSeries: ViewData.initial(),
      ),
    ],
    verify: (_) {
      verify(mockPopular.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, Error] when popular fails',
    build: () {
      when(
        mockPopular.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchPopularTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.loading(),
        topRatedTvSeries: ViewData.initial(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.error(
          failure: ServerFailure('Server Failure'),
        ),
        topRatedTvSeries: ViewData.initial(),
      ),
    ],
    verify: (_) {
      verify(mockPopular.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, HasData] when top rated success',
    build: () {
      when(
        mockTopRated.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchTopRatedTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.loading(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
      ),
    ],
    verify: (_) {
      verify(mockTopRated.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, NoData] when top rated returns empty',
    build: () {
      when(mockTopRated.execute()).thenAnswer((_) async => Right([]));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchTopRatedTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.loading(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.noData(),
      ),
    ],
    verify: (_) {
      verify(mockTopRated.execute());
    },
  );

  blocTest<TvseriesListCubit, TvseriesListState>(
    'Should emit [Loading, Error] when top rated fails',
    build: () {
      when(
        mockTopRated.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvseriesListBloc;
    },
    act: (bloc) => bloc.fetchTopRatedTvseries(),
    expect: () => [
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.loading(),
      ),
      TvseriesListState(
        nowPlayingTvSeries: ViewData.initial(),
        popularTvSeries: ViewData.initial(),
        topRatedTvSeries: ViewData.error(
          failure: ServerFailure('Server Failure'),
        ),
      ),
    ],
    verify: (_) {
      verify(mockTopRated.execute());
    },
  );
}
