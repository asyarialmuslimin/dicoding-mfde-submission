import 'package:movie/movie.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [MovieRepository, MovieRemoteDataSource, MovieLocalDataSource, MovieDao],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
