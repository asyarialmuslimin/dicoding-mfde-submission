part of 'tvseries_detail_cubit.dart';

class TvseriesDetailState extends Equatable {
  final ViewData<TvSeriesDetail> tvSeriesDetail;
  final ViewData<List<TvSeriesEntity>> tvSeriesRecommendations;
  final ViewData<bool> tvSeriesWishlistStatus;
  final ViewData<String> tvSeriesWatchlistMessage;

  const TvseriesDetailState({
    required this.tvSeriesDetail,
    required this.tvSeriesRecommendations,
    required this.tvSeriesWishlistStatus,
    required this.tvSeriesWatchlistMessage,
  });

  @override
  List<Object?> get props => [
    tvSeriesDetail,
    tvSeriesRecommendations,
    tvSeriesWishlistStatus,
    tvSeriesWatchlistMessage,
  ];

  TvseriesDetailState copyWith({
    ViewData<TvSeriesDetail>? tvSeriesDetail,
    ViewData<List<TvSeriesEntity>>? tvSeriesRecommendations,
    ViewData<bool>? tvSeriesWishlistStatus,
    ViewData<String>? tvSeriesWatchlistMessage,
  }) {
    return TvseriesDetailState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      tvSeriesWishlistStatus:
          tvSeriesWishlistStatus ?? this.tvSeriesWishlistStatus,
      tvSeriesWatchlistMessage:
          tvSeriesWatchlistMessage ?? this.tvSeriesWatchlistMessage,
    );
  }
}
