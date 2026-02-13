import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';

final testTVSeries = TvSeriesEntity(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [18, 80],
  id: 62560,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Mr. Robot',
  overview:
      'A young programmer, Elliot, suffers from a debilitating anti-social disorder and decides that he can only connect to people by hacking them.',
  popularity: 37.3808,
  posterPath: '/kv1nRqgebSsREnd7vdC2pSGjpLo.jpg',
  firstAirDate: '2015-06-24',
  name: 'Mr. Robot',
  voteAverage: 8.264,
  voteCount: 5162,
);

final testTVSeriesList = [testTVSeries];

final testTVSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  episodeRunTime: [45],
  firstAirDate: 'firstAirDate',
  genres: [Genre(id: 1, name: 'Drama')],
  homepage: 'https://google.com',
  id: 1,
  inProduction: false,
  languages: ['en'],
  lastAirDate: 'lastAirDate',
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1.0,
  posterPath: 'posterPath',
  status: 'Ended',
  tagline: 'tagline',
  type: 'Scripted',
  voteAverage: 1.0,
  voteCount: 1,
  lastEpisodeToAir: LastEpisodeToAir(
    id: 1,
    name: 'name',
    overview: 'overview',
    voteAverage: 1.0,
    voteCount: 1,
    airDate: 'airDate',
    episodeNumber: 1,
    episodeType: 'episodeType',
    productionCode: 'productionCode',
    runtime: 1,
    seasonNumber: 1,
    showId: 1,
    stillPath: 'stillPath',
  ),
  seasons: [
    Season(
      airDate: 'airDate',
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
      voteAverage: 1.0,
    ),
  ],
);

final testWatchlistTVSeries = TvSeriesEntity.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesTable = TVSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
