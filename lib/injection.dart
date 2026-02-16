import 'package:core/core.dart';
import 'package:ditonton/utils/http_client_helper.dart';
import 'package:movie/movie.dart';
import 'package:tvseries/tvseries.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> init() async {
  // external
  locator.registerSingletonAsync<http.Client>(() async => getHttpClient());

  await locator.isReady<http.Client>();

  // bloc
  locator.registerFactory(() => MovieSearchCubit(usecase: locator()));
  locator.registerFactory(() => MovieListCubit(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator()));
  locator.registerFactory(() => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchlistStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));
  locator.registerFactory(() => PopularMovieCubit(getPopularMovies: locator()));
  locator
      .registerFactory(() => TopRatedMovieCubit(getTopRatedMovies: locator()));
  locator.registerFactory(
      () => WatchlistMovieCubit(getWatchlistMovies: locator()));

  locator.registerFactory(() => TvseriesSearchCubit(searchTVSeries: locator()));
  locator.registerFactory(() => TvseriesListCubit(
      getNowPlayingTVSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator()));
  locator.registerFactory(() => TvseriesDetailCubit(
      getTvSeriesDetail: locator(),
      getTVSeriesRecommendations: locator(),
      getWatchlistStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));
  locator.registerFactory(
      () => PopularTvseriesCubit(getPopularTVSeries: locator()));
  locator.registerFactory(
      () => TopRatedTvseriesCubit(getTopRatedTVSeries: locator()));
  locator.registerFactory(
      () => WatchlistTvseriesCubit(getWatchlistTVSeries: locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTVSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTVSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVSeries(locator()));
  locator.registerLazySingleton(() => GetTVSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTVSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTVSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVSeriesStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVSeriesRepository>(
    () => TVSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // dao
  locator.registerLazySingleton<MovieDao>(
      () => MovieDaoImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TVSeriesDao>(
      () => TvseriesDaoImpl(databaseHelper: locator()));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator<http.Client>()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(movieDao: locator()));
  locator.registerLazySingleton<TVSeriesRemoteDataSource>(
      () => TVSeriesRemoteDataSourceImpl(client: locator<http.Client>()));
  locator.registerLazySingleton<TVSeriesLocalDataSource>(
      () => TVSeriesLocalDataSourceImpl(tvSeriesDao: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
