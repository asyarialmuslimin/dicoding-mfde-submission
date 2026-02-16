import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'tvseries_search_cubit_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late TvseriesSearchCubit tvseriesSearchBloc;
  late MockSearchTVSeries mockSearchTVSeries;

  setUp(() {
    mockSearchTVSeries = MockSearchTVSeries();
    tvseriesSearchBloc = TvseriesSearchCubit(
      searchTVSeries: mockSearchTVSeries,
    );
  });

  test('initial state should be empty', () {
    expect(
      tvseriesSearchBloc.state,
      TvseriesSearchState(searchResult: ViewData.initial()),
    );
  });

  final tTvSeriesModel = TvSeriesEntity(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [18, 80],
    id: 1396,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview:
        'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
    popularity: 200.441,
    posterPath: '/poster.jpg',
    firstAirDate: '2008-01-20',
    name: 'Breaking Bad',
    voteAverage: 8.9,
    voteCount: 10507,
  );

  final tTvSeriesList = <TvSeriesEntity>[tTvSeriesModel];
  final tQuery = 'breaking bad';

  blocTest<TvseriesSearchCubit, TvseriesSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(
        mockSearchTVSeries.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvseriesSearchBloc;
    },
    act: (bloc) => bloc.onQueryChanged(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvseriesSearchState(searchResult: ViewData.loading()),
      TvseriesSearchState(searchResult: ViewData.loaded(data: tTvSeriesList)),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQuery));
    },
  );

  blocTest<TvseriesSearchCubit, TvseriesSearchState>(
    'Should emit [Loading, NoData] when search returns empty',
    build: () {
      when(
        mockSearchTVSeries.execute(tQuery),
      ).thenAnswer((_) async => Right([]));

      return tvseriesSearchBloc;
    },
    act: (bloc) => bloc.onQueryChanged(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvseriesSearchState(searchResult: ViewData.loading()),
      TvseriesSearchState(searchResult: ViewData.noData()),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQuery));
    },
  );

  blocTest<TvseriesSearchCubit, TvseriesSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessfully',
    build: () {
      when(
        mockSearchTVSeries.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      return tvseriesSearchBloc;
    },
    act: (bloc) => bloc.onQueryChanged(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvseriesSearchState(searchResult: ViewData.loading()),
      TvseriesSearchState(
        searchResult: ViewData.error(failure: ServerFailure('Server Failure')),
      ),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQuery));
    },
  );
}
