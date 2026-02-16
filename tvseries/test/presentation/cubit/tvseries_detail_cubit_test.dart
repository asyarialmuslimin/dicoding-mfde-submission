import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'tvseries_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchlistTVSeriesStatus,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late TvseriesDetailCubit bloc;
  late MockGetTVSeriesDetail mockGetDetail;
  late MockGetTVSeriesRecommendations mockGetRecommendations;
  late MockGetWatchlistTVSeriesStatus mockGetWatchlistStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlist;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlist;

  final tId = 1;

  final tTvSeries = TvSeriesDetail(
    adult: false,
    backdropPath: 'path',
    episodeRunTime: [60],
    firstAirDate: '2020-01-01',
    genres: [Genre(id: 1, name: 'Drama')],
    homepage: 'https://homepage.com',
    id: tId,
    inProduction: false,
    languages: ['en'],
    lastAirDate: '2020-12-31',
    name: 'name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'original name',
    overview: 'overview',
    popularity: 100.0,
    posterPath: 'poster',
    status: 'Ended',
    tagline: 'tagline',
    type: 'Scripted',
    voteAverage: 8.0,
    voteCount: 100,
    lastEpisodeToAir: null,
    seasons: [],
  );

  final tTvSeriesList = [
    TvSeriesEntity.watchlist(
      id: 2,
      name: 'recommend',
      overview: 'overview',
      posterPath: 'poster',
    ),
  ];

  setUp(() {
    mockGetDetail = MockGetTVSeriesDetail();
    mockGetRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistTVSeriesStatus();
    mockSaveWatchlist = MockSaveWatchlistTVSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTVSeries();

    bloc = TvseriesDetailCubit(
      getTvSeriesDetail: mockGetDetail,
      getTVSeriesRecommendations: mockGetRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  test('initial state should be ViewData.initial()', () {
    expect(
      bloc.state,
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
    );
  });

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit [Loading, HasData] when get detail success',
    build: () {
      when(
        mockGetDetail.execute(tId),
      ).thenAnswer((_) async => Right(tTvSeries));
      return bloc;
    },
    act: (bloc) => bloc.fetchTvseriesDetail(tId),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.loading(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.loaded(data: tTvSeries),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
    ],
    verify: (_) => verify(mockGetDetail.execute(tId)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit [Loading, Error] when get detail fails',
    build: () {
      when(
        mockGetDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.fetchTvseriesDetail(tId),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.loading(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.error(
          failure: ServerFailure('Server Failure'),
        ),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
    ],
    verify: (_) => verify(mockGetDetail.execute(tId)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit [Loading, HasData] when recommendation success',
    build: () {
      when(
        mockGetRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.fetchTvseriesDetailRecommendations(tId),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.loading(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.loaded(data: tTvSeriesList),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
    ],
    verify: (_) => verify(mockGetRecommendations.execute(tId)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit [Loading, NoData] when recommendation returns empty',
    build: () {
      when(
        mockGetRecommendations.execute(tId),
      ).thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.fetchTvseriesDetailRecommendations(tId),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.loading(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.noData(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
    ],
    verify: (_) => verify(mockGetRecommendations.execute(tId)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit [HasData] when watchlist status success',
    build: () {
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.getTvseriesWatchlistStatus(tId),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.loaded(data: true),
        tvSeriesWatchlistMessage: ViewData.initial(),
      ),
    ],
    verify: (_) => verify(mockGetWatchlistStatus.execute(tId)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit success when add watchlist',
    build: () {
      when(
        mockSaveWatchlist.execute(tTvSeries),
      ).thenAnswer((_) async => Right(watchlistAddSuccessMessage));
      return bloc;
    },
    act: (bloc) => bloc.saveTvseriesWatchlist(tTvSeries),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.loading(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.loaded(data: true),
        tvSeriesWatchlistMessage: ViewData.loaded(
          data: watchlistAddSuccessMessage,
        ),
      ),
    ],
    verify: (_) => verify(mockSaveWatchlist.execute(tTvSeries)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit error when add watchlist fails',
    build: () {
      when(
        mockSaveWatchlist.execute(tTvSeries),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return bloc;
    },
    act: (bloc) => bloc.saveTvseriesWatchlist(tTvSeries),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.loading(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.error(
          failure: DatabaseFailure('Failed'),
        ),
      ),
    ],
    verify: (_) => verify(mockSaveWatchlist.execute(tTvSeries)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit success when remove watchlist',
    build: () {
      when(
        mockRemoveWatchlist.execute(tTvSeries),
      ).thenAnswer((_) async => Right(watchlistRemoveSuccessMessage));
      return bloc;
    },
    act: (bloc) => bloc.removeTvseriesWatchlist(tTvSeries),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.loading(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.loaded(data: false),
        tvSeriesWatchlistMessage: ViewData.loaded(
          data: watchlistRemoveSuccessMessage,
        ),
      ),
    ],
    verify: (_) => verify(mockRemoveWatchlist.execute(tTvSeries)),
  );

  blocTest<TvseriesDetailCubit, TvseriesDetailState>(
    'should emit error when remove watchlist fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(tTvSeries),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return bloc;
    },
    act: (bloc) => bloc.removeTvseriesWatchlist(tTvSeries),
    expect: () => [
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.loading(),
      ),
      TvseriesDetailState(
        tvSeriesDetail: ViewData.initial(),
        tvSeriesRecommendations: ViewData.initial(),
        tvSeriesWishlistStatus: ViewData.initial(),
        tvSeriesWatchlistMessage: ViewData.error(
          failure: DatabaseFailure('Failed'),
        ),
      ),
    ],
    verify: (_) => verify(mockRemoveWatchlist.execute(tTvSeries)),
  );
}
