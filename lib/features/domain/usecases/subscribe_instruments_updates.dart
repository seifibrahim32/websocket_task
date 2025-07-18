import 'package:raise_right_task/core/utils/di/di.dart' show sl;
import 'package:raise_right_task/features/data/models/prices_model.dart';
import 'package:raise_right_task/features/domain/repositories/IRepository.dart';
import 'package:raise_right_task/features/domain/repositories/InstrumentsRepository.dart';

class SubscribeInstrumentsUseCase {
  final IRepository instrumentsRepository = sl<InstrumentsRepository>();

  SubscribeInstrumentsUseCase();

  Stream<PricesModel> subscribeToPriceUpdates() {
    return instrumentsRepository.subscribeToPriceUpdates();
  }
  void dispose() {
    return instrumentsRepository.dispose();
  }

}
