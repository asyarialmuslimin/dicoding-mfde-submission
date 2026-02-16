import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

import 'package:flutter/material.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedMovieCubit>().onGetTopRatedMovie();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieCubit, TopRatedMovieState>(
          builder: (context, state) {
            if (state.topRatedMovies.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.topRatedMovies.isHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.topRatedMovies.data![index];
                  return MovieCard(movie);
                },
                itemCount: state.topRatedMovies.data!.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.topRatedMovies.message),
              );
            }
          },
        ),
      ),
    );
  }
}
