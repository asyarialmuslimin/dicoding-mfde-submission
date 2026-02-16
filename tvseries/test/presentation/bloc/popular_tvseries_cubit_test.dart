import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'popular_tvseries_cubit_test.mocks.dart';

@GenerateMocks([GetPopularTVSeries])
void main() {
  late PopularTvseriesCubit bloc;
  late MockGetPopularTVSeries mockGetPopularTVSeries;

  final tTvSeries = TvSeriesEntity.watchlist(
    id: 1,
    name: 'Test',
    overview: 'Overview',
    posterPath: '/test.jpg',
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeries];

  setUp(() {
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    bloc = PopularTvseriesCubit(getPopularTVSeries: mockGetPopularTVSeries);
  });

  test('initial state should be ViewData.initial()', () {
    expect(
      bloc.state,
      PopularTvseriesState(popularTvSeries: ViewData.initial()),
    );
  });

  blocTest<PopularTvseriesCubit, PopularTvseriesState>(
    'emit [Loading, HasData] when popular tv series success',
    build: () {
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.fetchPopularTvseries(),
    expect: () => [
      PopularTvseriesState(popularTvSeries: ViewData.loading()),
      PopularTvseriesState(
        popularTvSeries: ViewData.loaded(data: tTvSeriesList),
      ),
    ],
    verify: (_) {
      verify(mockGetPopularTVSeries.execute());
    },
  );

  blocTest<PopularTvseriesCubit, PopularTvseriesState>(
    'emit [Loading, Error] when popular tv series failed',
    build: () {
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.fetchPopularTvseries(),
    expect: () => [
      PopularTvseriesState(popularTvSeries: ViewData.loading()),
      PopularTvseriesState(
        popularTvSeries: ViewData.error(
          failure: ServerFailure('Server Failure'),
        ),
      ),
    ],
    verify: (_) {
      verify(mockGetPopularTVSeries.execute());
    },
  );
}
