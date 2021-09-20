import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/artist_list/data/repositories/rapper_repo_impl.dart';
import 'features/artist_list/data/sources/rapper_local_source.dart';
import 'features/artist_list/data/sources/rapper_remote_source.dart';
import 'features/artist_list/domain/repositories/rapper_repo.dart';
import 'features/artist_list/domain/usecases/get_concrete_rapper.dart';
import 'features/artist_list/presentation/bloc/rapper_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  /// Features - Rapper List
  /// Bloc
  getIt.registerFactory(() =>
      RapperBloc(getConcreteRapper: getIt(), getConcreteRapperList: getIt()));

  /// Use cases
  getIt.registerLazySingleton(() => GetConcreteRapper(getIt()));
  getIt.registerLazySingleton(() => GetConcreteRapperList(getIt()));

  /// Repository
  getIt.registerLazySingleton<RapperRepo>(() => RapperRepoImpl(
      remoteSource: getIt(), localSource: getIt(), networkInfo: getIt()));

  /// Data sources
  getIt.registerLazySingleton<RapperRemoteSource>(
      () => RapperRemoteSourceImpl(client: getIt()));
  getIt.registerLazySingleton<RapperLocalSource>(
      () => RapperLocalSourceImpl(sharedPreferences: getIt()));

  /// Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => Connectivity());
}
