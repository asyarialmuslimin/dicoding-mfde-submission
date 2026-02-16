import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:flutter/material.dart';

class WatchlistTVSeriesPage extends StatefulWidget {
  static const routeName = '/watchlist-tvseries';

  const WatchlistTVSeriesPage({super.key});

  @override
  State<WatchlistTVSeriesPage> createState() => _WatchlistTVSeriesPageState();
}

class _WatchlistTVSeriesPageState extends State<WatchlistTVSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WatchlistTvseriesCubit>().fetchWatchlistTvseries();
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
    context.read<WatchlistTvseriesCubit>().fetchWatchlistTvseries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvseriesCubit, WatchlistTvseriesState>(
          builder: (context, state) {
            if (state.watchlistTvSeries.isError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.watchlistTvSeries.failure!.message),
              );
            } else if (state.watchlistTvSeries.isHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.watchlistTvSeries.data![index];
                  return TVSeriesCard(tv);
                },
                itemCount: state.watchlistTvSeries.data!.length,
              );
            } else {
              return Center(child: CircularProgressIndicator());
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
