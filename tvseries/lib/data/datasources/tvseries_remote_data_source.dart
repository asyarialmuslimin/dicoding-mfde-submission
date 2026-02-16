import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tvseries/tvseries.dart';
import 'package:core/core.dart';

abstract class TVSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getNowPlayingSeries();
  Future<List<TvSeriesModel>> getTopRatedSeries();
  Future<List<TvSeriesModel>> searchTVSeries(String query);
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTVSeriesRecommendation(int id);
}

class TVSeriesRemoteDataSourceImpl implements TVSeriesRemoteDataSource {
  final http.Client client;

  TVSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getNowPlayingSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/airing_today?$apiKey'),
    );
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/top_rated?$apiKey'),
    );
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTVSeriesRecommendation(int id) async {
    final response = await client.get(
      Uri.parse("$baseUrl/tv/$id/recommendations?$apiKey"),
    );
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTVSeries(String query) async {
    final response = await client.get(
      Uri.parse("$baseUrl/search/tv?$apiKey&query=$query"),
    );
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
