import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tvseries/tvseries.dart';
import 'package:flutter/material.dart';

class TVSeriesSeasonListPage extends StatefulWidget {
  static const routeName = '/season-list-tvseries';
  final List<Season> listSeason;
  const TVSeriesSeasonListPage({super.key, required this.listSeason});

  @override
  State<TVSeriesSeasonListPage> createState() => _TVSeriesSeasonListPageState();
}

class _TVSeriesSeasonListPageState extends State<TVSeriesSeasonListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Season List')),
      body: ListView.builder(
        itemCount: widget.listSeason.length,
        itemBuilder: (context, index) {
          final season = widget.listSeason[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kGrey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (season.posterPath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${season.posterPath}',
                      width: 120,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          season.name,
                          style: kHeading6.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${season.airDate!.substring(0, 4)} • ${season.episodeCount} Episode",
                        ),
                        SizedBox(height: 8),
                        Text(
                          season.overview,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
