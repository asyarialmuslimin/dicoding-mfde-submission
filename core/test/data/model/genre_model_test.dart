import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  final tGenreJson = {'id': 1, 'name': 'Action'};

  final tGenre = Genre(id: 1, name: 'Action');

  group('GenreModel', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(tGenreModel, isA<Equatable>());
    });

    test('should return a valid model from JSON', () {
      // act
      final result = GenreModel.fromJson(tGenreJson);

      // assert
      expect(result, tGenreModel);
      expect(result.id, tGenreJson['id']);
      expect(result.name, tGenreJson['name']);
    });

    test('should return a JSON map containing proper data', () {
      // act
      final result = tGenreModel.toJson();

      // assert
      expect(result, tGenreJson);
      expect(result['id'], tGenreModel.id);
      expect(result['name'], tGenreModel.name);
    });

    test('should return a valid Genre entity', () {
      // act
      final result = tGenreModel.toEntity();

      // assert
      expect(result, tGenre);
      expect(result.id, tGenreModel.id);
      expect(result.name, tGenreModel.name);
    });

    test('should be equal when all properties are the same', () {
      // arrange
      final genreModel1 = GenreModel(id: 1, name: 'Action');
      final genreModel2 = GenreModel(id: 1, name: 'Action');

      // assert
      expect(genreModel1, equals(genreModel2));
    });
  });
}
