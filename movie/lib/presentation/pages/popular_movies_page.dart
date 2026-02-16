import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularMovieCubit>().onGetPopularMovie();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieCubit, PopularMovieState>(
          builder: (context, state) {
            if (state.popularMovies.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.popularMovies.isHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.popularMovies.data![index];
                  return MovieCard(movie);
                },
                itemCount: state.popularMovies.data!.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.popularMovies.message),
              );
            }
          },
        ),
      ),
    );
  }
}
