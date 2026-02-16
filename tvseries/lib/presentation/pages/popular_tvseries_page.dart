import 'package:tvseries/tvseries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVSeriesPage extends StatefulWidget {
  static const routeName = '/popular-tvseries';

  const PopularTVSeriesPage({super.key});

  @override
  State<PopularTVSeriesPage> createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularTvseriesCubit>().fetchPopularTvseries();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvseriesCubit, PopularTvseriesState>(
          builder: (context, state) {
            if (state.popularTvSeries.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.popularTvSeries.isHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.popularTvSeries.data![index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: state.popularTvSeries.data!.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.popularTvSeries.message),
              );
            }
          },
        ),
      ),
    );
  }
}
