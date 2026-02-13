import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetPopularTVSeries(mockTVSeriesRepository);
  });

  final tTVSeries = <TvSeriesEntity>[];

  group('GetPopularTVSeries Tests', () {
    group('execute', () {
      test(
        'should get list of TV series from the repository when execute function is called',
        () async {
          // arrange
          when(
            mockTVSeriesRepository.getPopularTVSeries(),
          ).thenAnswer((_) async => Right(tTVSeries));
          // act
          final result = await usecase.execute();
          // assert
          expect(result, Right(tTVSeries));
        },
      );
    });
  });
}
