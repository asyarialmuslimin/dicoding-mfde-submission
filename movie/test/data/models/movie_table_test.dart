import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  group('MovieTable', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tMovieTable, isA<Equatable>());
    });

    group('fromEntity', () {
      test('should return a valid MovieTable from MovieDetail', () {
        // act
        final result = MovieTable.fromEntity(tMovieDetail);

        // assert
        expect(result, tMovieTable);
        expect(result.id, tMovieDetail.id);
        expect(result.title, tMovieDetail.title);
        expect(result.posterPath, tMovieDetail.posterPath);
        expect(result.overview, tMovieDetail.overview);
      });
    });

    group('fromMap', () {
      test('should return a valid MovieTable from Map', () {
        // act
        final result = MovieTable.fromMap(tMovieMap);

        // assert
        expect(result, tMovieTable);
        expect(result.id, tMovieMap['id']);
        expect(result.title, tMovieMap['title']);
        expect(result.posterPath, tMovieMap['posterPath']);
        expect(result.overview, tMovieMap['overview']);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tMovieTable.toJson();

        // assert
        expect(result, tMovieMap);
        expect(result['id'], tMovieTable.id);
        expect(result['title'], tMovieTable.title);
        expect(result['posterPath'], tMovieTable.posterPath);
        expect(result['overview'], tMovieTable.overview);
      });
    });

    group('toEntity', () {
      test('should return a valid MovieEntity', () {
        // act
        final result = tMovieTable.toEntity();

        // assert
        expect(result, isA<MovieEntity>());
        expect(result.id, tMovieTable.id);
        expect(result.title, tMovieTable.title);
        expect(result.posterPath, tMovieTable.posterPath);
        expect(result.overview, tMovieTable.overview);
      });
    });

    group('props', () {
      test('should return correct props for equality comparison', () {
        // act
        final props = tMovieTable.props;

        // assert
        expect(props, [
          tMovieTable.id,
          tMovieTable.title,
          tMovieTable.posterPath,
          tMovieTable.overview,
        ]);
      });

      test('should be equal when all properties are the same', () {
        // arrange
        final movieTable1 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );
        final movieTable2 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );

        // assert
        expect(movieTable1, equals(movieTable2));
      });

      test('should not be equal when properties are different', () {
        // arrange
        final movieTable1 = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );
        final movieTable2 = MovieTable(
          id: 2,
          title: 'title',
          posterPath: 'posterPath',
          overview: 'overview',
        );

        // assert
        expect(movieTable1, isNot(equals(movieTable2)));
      });
    });

    group('Nullable fields', () {
      test('should handle null title', () {
        // arrange
        final movieTable = MovieTable(
          id: 1,
          title: null,
          posterPath: 'posterPath',
          overview: 'overview',
        );

        // assert
        expect(movieTable.title, null);
        expect(movieTable.toJson()['title'], null);
      });

      test('should handle null posterPath', () {
        // arrange
        final movieTable = MovieTable(
          id: 1,
          title: 'title',
          posterPath: null,
          overview: 'overview',
        );

        // assert
        expect(movieTable.posterPath, null);
        expect(movieTable.toJson()['posterPath'], null);
      });

      test('should handle null overview', () {
        // arrange
        final movieTable = MovieTable(
          id: 1,
          title: 'title',
          posterPath: 'posterPath',
          overview: null,
        );

        // assert
        expect(movieTable.overview, null);
        expect(movieTable.toJson()['overview'], null);
      });

      test('should handle all nullable fields being null', () {
        // arrange
        final movieTable = MovieTable(
          id: 1,
          title: null,
          posterPath: null,
          overview: null,
        );

        final expectedMap = {
          'id': 1,
          'title': null,
          'posterPath': null,
          'overview': null,
        };

        // assert
        expect(movieTable.toJson(), expectedMap);
      });
    });
  });
}
