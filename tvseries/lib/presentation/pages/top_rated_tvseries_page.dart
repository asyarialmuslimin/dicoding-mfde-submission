import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:flutter/material.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  static const routeName = '/top-rated-tvseries';

  const TopRatedTVSeriesPage({super.key});

  @override
  State<TopRatedTVSeriesPage> createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedTvseriesCubit>().fetchTopRatedTvseries();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvseriesCubit, TopRatedTvseriesState>(
          builder: (context, state) {
            if (state.topRatedTvSeries.isHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.topRatedTvSeries.data![index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: state.topRatedTvSeries.data!.length,
              );
            } else if (state.topRatedTvSeries.isError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.topRatedTvSeries.failure!.message),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
