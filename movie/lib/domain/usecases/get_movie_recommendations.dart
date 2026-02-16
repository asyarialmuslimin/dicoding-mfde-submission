import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:movie/movie.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<MovieEntity>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}
