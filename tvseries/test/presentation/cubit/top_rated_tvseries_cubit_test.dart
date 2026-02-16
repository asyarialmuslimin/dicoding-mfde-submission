import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'top_rated_tvseries_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTVSeries])
void main() {
  late TopRatedTvseriesCubit bloc;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

  final tTvSeries = TvSeriesEntity.watchlist(
    id: 1,
    name: 'Test',
    overview: 'Overview',
    posterPath: '/test.jpg',
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeries];

  setUp(() {
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    bloc = TopRatedTvseriesCubit(getTopRatedTVSeries: mockGetTopRatedTVSeries);
  });

  test('initial state should be ViewData.initial()', () {
    expect(
      bloc.state,
      TopRatedTvseriesState(topRatedTvSeries: ViewData.initial()),
    );
  });

  blocTest<TopRatedTvseriesCubit, TopRatedTvseriesState>(
    'emit [Loading, HasData] when top rated tv series success',
    build: () {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.fetchTopRatedTvseries(),
    expect: () => [
      TopRatedTvseriesState(topRatedTvSeries: ViewData.loading()),
      TopRatedTvseriesState(
        topRatedTvSeries: ViewData.loaded(data: tTvSeriesList),
      ),
    ],
    verify: (_) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );

  blocTest<TopRatedTvseriesCubit, TopRatedTvseriesState>(
    'emit [Loading, Error] when top rated tv series failed',
    build: () {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.fetchTopRatedTvseries(),
    expect: () => [
      TopRatedTvseriesState(topRatedTvSeries: ViewData.loading()),
      TopRatedTvseriesState(
        topRatedTvSeries: ViewData.error(
          failure: ServerFailure('Server Failure'),
        ),
      ),
    ],
    verify: (_) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );
}
