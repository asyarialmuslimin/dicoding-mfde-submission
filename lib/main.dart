import 'package:ditonton/presentation/pages/home_ditonton_page.dart';

import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tvseries/tvseries.dart';
import 'package:about/about.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvseriesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvseriesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvseriesCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: baseTextTheme,
          drawerTheme: baseDrawerTheme,
        ),
        home: HomeDitontonPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTVSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistTVSeriesPage());
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case PopularTVSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularTVSeriesPage());
            case TopRatedTVSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedTVSeriesPage());
            case TVSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVSeriesDetailPage(id: id),
                settings: settings,
              );
            case TVSeriesSeasonListPage.routeName:
              final seasons = settings.arguments as List<Season>;
              return MaterialPageRoute(
                builder: (_) => TVSeriesSeasonListPage(listSeason: seasons),
                settings: settings,
              );
            case TVSeriesSearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => TVSeriesSearchPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
