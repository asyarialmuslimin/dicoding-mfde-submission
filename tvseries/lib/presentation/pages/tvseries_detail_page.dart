import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVSeriesDetailPage extends StatefulWidget {
  static const routeName = '/detail-tvseries';

  final int id;
  const TVSeriesDetailPage({super.key, required this.id});

  @override
  State<TVSeriesDetailPage> createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvseriesDetailCubit>()
          ..fetchTvseriesDetail(widget.id)
          ..fetchTvseriesDetailRecommendations(widget.id)
          ..getTvseriesWatchlistStatus(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvseriesDetailCubit, TvseriesDetailState>(
        listenWhen: (previous, current) {
          return previous.tvSeriesWatchlistMessage !=
              current.tvSeriesWatchlistMessage;
        },
        listener: (context, state) {
          if (state.tvSeriesWatchlistMessage.isHasData) {
            final message = state.tvSeriesWatchlistMessage.data!;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          } else if (state.tvSeriesWatchlistMessage.isError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    state.tvSeriesWatchlistMessage.failure!.message,
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state.tvSeriesDetail.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.tvSeriesDetail.isHasData) {
            final tvSeries = state.tvSeriesDetail.data;
            return SafeArea(
              child: DetailContent(
                tvSeries!,
                state.tvSeriesWishlistStatus.isHasData
                    ? state.tvSeriesWishlistStatus.data!
                    : false,
              ),
            );
          } else {
            return Text(state.tvSeriesDetail.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final bool isAddedWatchlist;

  const DetailContent(this.tvSeries, this.isAddedWatchlist, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvseriesDetailCubit>()
                                      .saveTvseriesWatchlist(tvSeries);
                                } else {
                                  context
                                      .read<TvseriesDetailCubit>()
                                      .removeTvseriesWatchlist(tvSeries);
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tvSeries.genres)),
                            Text(
                              'Episodes: ${tvSeries.numberOfEpisodes}, Seasons: ${tvSeries.numberOfSeasons}',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: kMikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            SizedBox(height: 16),
                            if (tvSeries.lastEpisodeToAir != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Last Episode', style: kHeading6),
                                  SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: kGrey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (tvSeries
                                                .lastEpisodeToAir!
                                                .stillPath !=
                                            null)
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tvSeries.lastEpisodeToAir!.stillPath}',
                                              width: 120,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tvSeries
                                                      .lastEpisodeToAir!
                                                      .name,
                                                  style: kSubtitle.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  tvSeries
                                                      .lastEpisodeToAir!
                                                      .airDate
                                                      .substring(0, 4),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  tvSeries
                                                      .lastEpisodeToAir!
                                                      .overview,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            Row(
                              children: [
                                Text('Last Season', style: kHeading6),
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      TVSeriesSeasonListPage.routeName,
                                      arguments: tvSeries.seasons,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('See More'),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kGrey,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tvSeries.seasons.last.posterPath != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${tvSeries.seasons.last.posterPath}',
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tvSeries.seasons.last.name,
                                            style: kSubtitle.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            tvSeries.lastEpisodeToAir!.airDate
                                                .substring(0, 4),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            tvSeries.seasons.last.overview,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<
                              TvseriesDetailCubit,
                              TvseriesDetailState
                            >(
                              builder: (context, state) {
                                if (state.tvSeriesRecommendations.isLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    .tvSeriesRecommendations
                                    .isError) {
                                  return Text(
                                    state.tvSeriesRecommendations.message,
                                  );
                                } else if (state
                                    .tvSeriesRecommendations
                                    .isHasData) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = state
                                            .tvSeriesRecommendations
                                            .data![index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVSeriesDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state
                                          .tvSeriesRecommendations
                                          .data!
                                          .length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
