import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

void main() {
  final tTVSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: "/8zbAoryWbtH0DKdev8abFAjdufy.jpg",
    genreIds: [10765, 9648, 10759],
    id: 66732,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Stranger Things",
    overview:
        "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
    popularity: 306.2136,
    posterPath: "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg",
    firstAirDate: "2016-07-15",
    name: "Stranger Things",
    voteAverage: 8.581,
    voteCount: 20552,
  );

  final tTVSeriesResponseModel = TvSeriesResponse(
    tvSeriesList: <TvSeriesModel>[tTVSeriesModel],
  );

  group("fromJson", () {
    test("should return a valid model from JSON", () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson("dummy_data/tvseries_popular.json"),
      );
      final result = TvSeriesResponse.fromJson(jsonMap);
      expect(result, tTVSeriesResponseModel);
    });
  });

  group("toJson", () {
    test("should return a JSON map containing proper data", () async {
      final result = tTVSeriesResponseModel.toJson();
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/8zbAoryWbtH0DKdev8abFAjdufy.jpg",
            "genre_ids": [10765, 9648, 10759],
            "id": 66732,
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Stranger Things",
            "overview":
                "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
            "popularity": 306.2136,
            "poster_path": "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg",
            "first_air_date": "2016-07-15",
            "name": "Stranger Things",
            "vote_average": 8.581,
            "vote_count": 20552,
          },
        ],
      };

      expect(result, expectedJsonMap);
    });
  });
}
