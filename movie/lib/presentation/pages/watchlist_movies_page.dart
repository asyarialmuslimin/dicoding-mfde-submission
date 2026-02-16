import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

import 'package:flutter/material.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const routeName = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WatchlistMovieCubit>().onGetWatchlistMovie();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieCubit>().onGetWatchlistMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMovieCubit, WatchlistMovieState>(
          builder: (context, state) {
            if (state.watchlistMovies.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.watchlistMovies.isHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.watchlistMovies.data![index];
                  return MovieCard(movie);
                },
                itemCount: state.watchlistMovies.data!.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.watchlistMovies.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
