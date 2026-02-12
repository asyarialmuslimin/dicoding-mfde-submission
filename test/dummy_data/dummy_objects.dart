import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tvseries_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/last_episode_to_air.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testTVSeries = TvSeries(
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

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchlistTVSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesTable = TVSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTVSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
