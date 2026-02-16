import 'dart:convert';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 100000000,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://homepage.com',
    id: 1,
    imdbId: 'tt1234567',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 100.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-01-01',
    revenue: 200000000,
    runtime: 120,
    status: 'Released',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 1000,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-01-01',
    runtime: 120,
    title: 'Title',
    voteAverage: 8.0,
    voteCount: 1000,
  );

  group('MovieDetailResponse', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tMovieDetailResponse, isA<Equatable>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          readJson('dummy_data/movie_detail.json'),
        );

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result, isA<MovieDetailResponse>());
        expect(result.id, jsonMap['id']);
        expect(result.title, jsonMap['title']);
        expect(result.overview, jsonMap['overview']);
      });

      test('should correctly parse all fields from JSON', () {
        // arrange
        final jsonMap = {
          "adult": false,
          "backdrop_path": "/path.jpg",
          "budget": 100000000,
          "genres": [
            {"id": 1, "name": "Action"},
          ],
          "homepage": "https://homepage.com",
          "id": 1,
          "imdb_id": "tt1234567",
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 100.0,
          "poster_path": "/path.jpg",
          "release_date": "2020-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 8.0,
          "vote_count": 1000,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result, tMovieDetailResponse);
        expect(result.adult, false);
        expect(result.backdropPath, '/path.jpg');
        expect(result.budget, 100000000);
        expect(result.genres.length, 1);
        expect(result.homepage, 'https://homepage.com');
        expect(result.id, 1);
        expect(result.imdbId, 'tt1234567');
        expect(result.originalLanguage, 'en');
        expect(result.originalTitle, 'Original Title');
        expect(result.overview, 'Overview');
        expect(result.popularity, 100.0);
        expect(result.posterPath, '/path.jpg');
        expect(result.releaseDate, '2020-01-01');
        expect(result.revenue, 200000000);
        expect(result.runtime, 120);
        expect(result.status, 'Released');
        expect(result.tagline, 'Tagline');
        expect(result.title, 'Title');
        expect(result.video, false);
        expect(result.voteAverage, 8.0);
        expect(result.voteCount, 1000);
      });

      test('should handle nullable fields correctly', () {
        // arrange
        final jsonMap = {
          "adult": false,
          "backdrop_path": null,
          "budget": 100000000,
          "genres": [],
          "homepage": "https://homepage.com",
          "id": 1,
          "imdb_id": null,
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 100.0,
          "poster_path": "/path.jpg",
          "release_date": "2020-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 8.0,
          "vote_count": 1000,
        };

        // act
        final result = MovieDetailResponse.fromJson(jsonMap);

        // assert
        expect(result.backdropPath, null);
        expect(result.imdbId, null);
        expect(result.genres, []);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tMovieDetailResponse.toJson();

        // assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 1);
        expect(result['title'], 'Title');
        expect(result['adult'], false);
        expect(result['backdrop_path'], '/path.jpg');
        expect(result['budget'], 100000000);
        expect(result['genres'], isA<List>());
        expect(result['homepage'], 'https://homepage.com');
        expect(result['imdb_id'], 'tt1234567');
        expect(result['original_language'], 'en');
        expect(result['original_title'], 'Original Title');
        expect(result['overview'], 'Overview');
        expect(result['popularity'], 100.0);
        expect(result['poster_path'], '/path.jpg');
        expect(result['release_date'], '2020-01-01');
        expect(result['revenue'], 200000000);
        expect(result['runtime'], 120);
        expect(result['status'], 'Released');
        expect(result['tagline'], 'Tagline');
        expect(result['video'], false);
        expect(result['vote_average'], 8.0);
        expect(result['vote_count'], 1000);
      });

      test('should use correct JSON keys with snake_case', () {
        // act
        final result = tMovieDetailResponse.toJson();

        // assert
        expect(result.containsKey('backdrop_path'), true);
        expect(result.containsKey('imdb_id'), true);
        expect(result.containsKey('original_language'), true);
        expect(result.containsKey('original_title'), true);
        expect(result.containsKey('poster_path'), true);
        expect(result.containsKey('release_date'), true);
        expect(result.containsKey('vote_average'), true);
        expect(result.containsKey('vote_count'), true);
      });
    });

    group('toEntity', () {
      test('should return a valid MovieDetail entity', () {
        // act
        final result = tMovieDetailResponse.toEntity();

        // assert
        expect(result, isA<MovieDetail>());
        expect(result, tMovieDetail);
      });

      test('should map all relevant fields to MovieDetail', () {
        // act
        final result = tMovieDetailResponse.toEntity();

        // assert
        expect(result.adult, tMovieDetailResponse.adult);
        expect(result.backdropPath, tMovieDetailResponse.backdropPath);
        expect(result.genres.length, tMovieDetailResponse.genres.length);
        expect(result.id, tMovieDetailResponse.id);
        expect(result.originalTitle, tMovieDetailResponse.originalTitle);
        expect(result.overview, tMovieDetailResponse.overview);
        expect(result.posterPath, tMovieDetailResponse.posterPath);
        expect(result.releaseDate, tMovieDetailResponse.releaseDate);
        expect(result.runtime, tMovieDetailResponse.runtime);
        expect(result.title, tMovieDetailResponse.title);
        expect(result.voteAverage, tMovieDetailResponse.voteAverage);
        expect(result.voteCount, tMovieDetailResponse.voteCount);
      });

      test('should convert GenreModel to Genre correctly', () {
        // act
        final result = tMovieDetailResponse.toEntity();

        // assert
        expect(result.genres[0].id, 1);
        expect(result.genres[0].name, 'Action');
        expect(result.genres[0], isA<Genre>());
      });
    });

    group('props', () {
      test('should return correct props for equality comparison', () {
        // act
        final props = tMovieDetailResponse.props;

        // assert
        expect(props.length, 21);
        expect(props.contains(tMovieDetailResponse.id), true);
        expect(props.contains(tMovieDetailResponse.title), true);
        expect(props.contains(tMovieDetailResponse.overview), true);
      });

      test('should be equal when all properties are the same', () {
        // arrange
        final response1 = MovieDetailResponse(
          adult: false,
          backdropPath: '/path.jpg',
          budget: 100000000,
          genres: [GenreModel(id: 1, name: 'Action')],
          homepage: 'https://homepage.com',
          id: 1,
          imdbId: 'tt1234567',
          originalLanguage: 'en',
          originalTitle: 'Original Title',
          overview: 'Overview',
          popularity: 100.0,
          posterPath: '/path.jpg',
          releaseDate: '2020-01-01',
          revenue: 200000000,
          runtime: 120,
          status: 'Released',
          tagline: 'Tagline',
          title: 'Title',
          video: false,
          voteAverage: 8.0,
          voteCount: 1000,
        );

        final response2 = MovieDetailResponse(
          adult: false,
          backdropPath: '/path.jpg',
          budget: 100000000,
          genres: [GenreModel(id: 1, name: 'Action')],
          homepage: 'https://homepage.com',
          id: 1,
          imdbId: 'tt1234567',
          originalLanguage: 'en',
          originalTitle: 'Original Title',
          overview: 'Overview',
          popularity: 100.0,
          posterPath: '/path.jpg',
          releaseDate: '2020-01-01',
          revenue: 200000000,
          runtime: 120,
          status: 'Released',
          tagline: 'Tagline',
          title: 'Title',
          video: false,
          voteAverage: 8.0,
          voteCount: 1000,
        );

        // assert
        expect(response1, equals(response2));
      });

      test('should not be equal when properties are different', () {
        // arrange
        final response1 = tMovieDetailResponse;
        final response2 = MovieDetailResponse(
          adult: false,
          backdropPath: '/path.jpg',
          budget: 100000000,
          genres: [GenreModel(id: 1, name: 'Action')],
          homepage: 'https://homepage.com',
          id: 2, // Different ID
          imdbId: 'tt1234567',
          originalLanguage: 'en',
          originalTitle: 'Original Title',
          overview: 'Overview',
          popularity: 100.0,
          posterPath: '/path.jpg',
          releaseDate: '2020-01-01',
          revenue: 200000000,
          runtime: 120,
          status: 'Released',
          tagline: 'Tagline',
          title: 'Title',
          video: false,
          voteAverage: 8.0,
          voteCount: 1000,
        );

        // assert
        expect(response1, isNot(equals(response2)));
      });
    });

    group('JSON serialization round-trip', () {
      test('should maintain data integrity through fromJson -> toJson', () {
        // arrange
        final originalJson = {
          "adult": false,
          "backdrop_path": "/path.jpg",
          "budget": 100000000,
          "genres": [
            {"id": 1, "name": "Action"},
          ],
          "homepage": "https://homepage.com",
          "id": 1,
          "imdb_id": "tt1234567",
          "original_language": "en",
          "original_title": "Original Title",
          "overview": "Overview",
          "popularity": 100.0,
          "poster_path": "/path.jpg",
          "release_date": "2020-01-01",
          "revenue": 200000000,
          "runtime": 120,
          "status": "Released",
          "tagline": "Tagline",
          "title": "Title",
          "video": false,
          "vote_average": 8.0,
          "vote_count": 1000,
        };

        // act
        final model = MovieDetailResponse.fromJson(originalJson);
        final resultJson = model.toJson();

        // assert
        expect(resultJson['id'], originalJson['id']);
        expect(resultJson['title'], originalJson['title']);
        expect(resultJson['overview'], originalJson['overview']);
        expect(resultJson['runtime'], originalJson['runtime']);
      });
    });
  });
}
