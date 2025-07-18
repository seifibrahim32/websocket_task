import 'package:dartz/dartz.dart';
import 'package:raise_right_task/features/data/models/instruments_model.dart';
import 'package:raise_right_task/features/data/models/prices_model.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/di/di.dart' show sl;
import '../../data/datasources/crypto_remote_datasource.dart';
import 'package:raise_right_task/features/domain/repositories/IRepository.dart';
import '../../../core/utils/di/di.dart';

class InstrumentsRepository implements IRepository {
  late final CryptoRemoteDataSource remoteDataSource =
  sl<CryptoRemoteDataSourceImpl>();

  final List<String> allowedSymbols = [
    'BTC',
    'ETH',
    'XRP',
    'BNB',
    'SOL',
    'DOGE',
    'TRX',
    'HBAR',
    'HUMA',
    'HMSTR'
    'ADA',
    'XLM',
  ];
  final List<String> instIDs = [];
  @override
  Future<Either<Failure, List<InstrumentModel>>> fetchInitialInstruments() async {
    final eitherResult = await remoteDataSource.fetchInitialInstruments();
    return eitherResult.map((list) {
      return list.where((item) {
            var inTheList = allowedSymbols.contains(item.baseCcy.toUpperCase());
            if(!instIDs.contains(item.instId) && inTheList){
              instIDs.add(item.instId);
            }
            return inTheList;
          })
          .toList();
    });
  }

  @override
  Stream<PricesModel> subscribeToPriceUpdates() async* {
    var rawStream = remoteDataSource.subscribeToWebSocketEvents(instIDs);
    yield* rawStream;
  }


  @override
  void dispose() {
    remoteDataSource.disposeWebSocket();
  }
}
