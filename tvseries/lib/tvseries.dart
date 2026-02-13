library tvseries;

export 'domain/entities/tvseries.dart';
export 'domain/entities/tvseries_detail.dart';
export 'domain/entities/season.dart';
export 'domain/entities/last_episode_to_air.dart';

export 'data/models/tvseries_model.dart';
export 'data/models/tvseries_table.dart';
export 'data/models/tvseries_detail_model.dart';
export 'data/models/season_model.dart';
export 'data/models/last_episode_to_air_model.dart';
export 'data/models/tvseries_response.dart';

export 'data/datasources/db/tvseries.dao.dart';

export 'data/datasources/tvseries_local_data_source.dart';
export 'data/datasources/tvseries_remote_data_source.dart';

export 'data/repositories/tvseries_repository_impl.dart';

export 'domain/repositories/tvseries_repository.dart';
export 'domain/usecases/get_now_playing_tvseries.dart';
export 'domain/usecases/get_popular_tvseries.dart';
export 'domain/usecases/get_top_rated_tvseries.dart';
export 'domain/usecases/get_watchlist_tvseries.dart';
export 'domain/usecases/get_watchlist_tvseries_status.dart';
export 'domain/usecases/remove_watchlist_tvseries.dart';
export 'domain/usecases/save_watchlist_tvseries.dart';
export 'domain/usecases/search_tvseries.dart';
export 'domain/usecases/get_tvseries_detail.dart';
export 'domain/usecases/get_tvseries_recommendations.dart';

export 'presentation/provider/tvseries_detail_notifier.dart';
export 'presentation/provider/tvseries_list_notifier.dart';
export 'presentation/provider/tvseries_search_notifier.dart';
export 'presentation/provider/popular_tvseries_notifier.dart';
export 'presentation/provider/top_rated_tvseries_notifier.dart';
export 'presentation/provider/watchlist_tvseries_notifier.dart';

export 'presentation/pages/home_tvseries_page.dart';
export 'presentation/pages/tvseries_detail_page.dart';
export 'presentation/pages/popular_tvseries_page.dart';
export 'presentation/pages/tvseries_search_page.dart';
export 'presentation/pages/top_rated_tvseries_page.dart';
export 'presentation/pages/watchlist_tvseries_page.dart';
export 'presentation/pages/tvseries_season_list_page.dart';

export 'presentation/widgets/tvseries_card_list.dart';
