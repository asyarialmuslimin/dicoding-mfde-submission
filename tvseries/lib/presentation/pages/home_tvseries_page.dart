import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVSeriesPage extends StatefulWidget {
  const HomeTVSeriesPage({super.key});

  @override
  State<HomeTVSeriesPage> createState() => _HomeTVSeriesPageState();
}

class _HomeTVSeriesPageState extends State<HomeTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvseriesListCubit>()
          ..fetchNowPlayingTvseries()
          ..fetchPopularTvseries()
          ..fetchTopRatedTvseries();
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
                Navigator.pushNamed(context, WatchlistTVSeriesPage.routeName);
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
        title: Text('Ditonton : TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TVSeriesSearchPage.routeName);
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
              Text('Now Playing', style: kHeading6),
              BlocBuilder<TvseriesListCubit, TvseriesListState>(
                builder: (context, state) {
                  if (state.nowPlayingTvSeries.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.nowPlayingTvSeries.isHasData) {
                    return TVSeriesList(state.nowPlayingTvSeries.data!);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVSeriesPage.routeName),
              ),
              BlocBuilder<TvseriesListCubit, TvseriesListState>(
                builder: (context, state) {
                  if (state.popularTvSeries.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.popularTvSeries.isHasData) {
                    return TVSeriesList(state.popularTvSeries.data!);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedTVSeriesPage.routeName,
                ),
              ),
              BlocBuilder<TvseriesListCubit, TvseriesListState>(
                builder: (context, state) {
                  if (state.topRatedTvSeries.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.topRatedTvSeries.isHasData) {
                    return TVSeriesList(state.topRatedTvSeries.data!);
                  } else {
                    return Text('Failed');
                  }
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
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TVSeriesList extends StatelessWidget {
  final List<TvSeriesEntity> tvSeries;

  const TVSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVSeriesDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
