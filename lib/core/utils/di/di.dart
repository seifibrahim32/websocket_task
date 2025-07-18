import 'package:get_it/get_it.dart';
import 'package:raise_right_task/features/data/datasources/crypto_remote_datasource.dart';
import 'package:raise_right_task/features/domain/usecases/get_instruments_usecase.dart' show GetInstrumentsUseCase;
import 'package:raise_right_task/features/presentation/bloc/instruments_bloc.dart';

import '../../../features/domain/repositories/InstrumentsRepository.dart' show InstrumentsRepository;
import '../../../features/domain/usecases/subscribe_instruments_updates.dart' show SubscribeInstrumentsUseCase;

var sl = GetIt.instance;
void setupLocators(){
  sl.registerLazySingleton(() => InstrumentsBloc());
  sl.registerLazySingleton(() => InstrumentsRepository());
  sl.registerLazySingleton(() => GetInstrumentsUseCase());
  sl.registerLazySingleton(() => SubscribeInstrumentsUseCase());
  sl.registerFactory(() => CryptoRemoteDataSourceImpl());
}