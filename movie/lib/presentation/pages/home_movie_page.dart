import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<MovieListCubit>().onGetNowPlayingMovie();
        context.read<MovieListCubit>().onGetPopularMovie();
        context.read<MovieListCubit>().onGetTopRatedMovie();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton : Movie'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NOW PLAYING SECTION
              Text('Now Playing', style: kHeading6),
              BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.nowPlayingMovies.isNoData) {
                    return _buildEmptyWidget();
                  }

                  if (state.nowPlayingMovies.isError) {
                    return _buildErrorWidget(state.nowPlayingMovies.failure!);
                  }

                  // Cek data
                  if (state.nowPlayingMovies.isHasData) {
                    return MovieList(state.nowPlayingMovies.data!);
                  }

                  return _buildLoadingWidget();
                },
              ),

              SizedBox(height: 16),

              // POPULAR SECTION
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.routeName),
              ),
              BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.popularMovies.status.isNoData) {
                    return _buildEmptyWidget();
                  }

                  if (state.popularMovies.status.isError) {
                    return _buildErrorWidget(state.popularMovies.failure!);
                  }

                  if (state.popularMovies.status.isHasData) {
                    return MovieList(state.popularMovies.data!);
                  }

                  return _buildLoadingWidget();
                },
              ),

              SizedBox(height: 16),

              // TOP RATED SECTION
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.routeName),
              ),
              BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.topRatedMovies.status.isNoData) {
                    return _buildEmptyWidget();
                  }

                  if (state.topRatedMovies.status.isError) {
                    return _buildErrorWidget(state.topRatedMovies.failure!);
                  }

                  if (state.topRatedMovies.status.isHasData) {
                    return MovieList(state.topRatedMovies.data!);
                  }

                  return _buildLoadingWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('See More'),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget(Failure failure) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(failure.message, style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return SizedBox(
      height: 200,
      child: Center(child: Text('No movies available')),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<MovieEntity> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
