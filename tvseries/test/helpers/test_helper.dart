import 'package:tvseries/tvseries.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    TVSeriesRepository,
    TVSeriesRemoteDataSource,
    TVSeriesLocalDataSource,
    TVSeriesDao,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
