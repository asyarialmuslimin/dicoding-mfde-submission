import 'package:ditonton/data/models/tvseries_model.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: "backdropPath",
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ["A"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    firstAirDate: "firstAirDate",
    name: "name",
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVSeries = TvSeries(
    adult: false,
    backdropPath: "backdropPath",
    genreIds: [1,2,3],
    id: 1,
    originCountry: ["A"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    firstAirDate: "firstAirDate",
    name: "name",
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of TVSeries entity', () async {
    final result = tTVSeriesModel.toEntity();
    expect(result, tTVSeries);
  });
}
