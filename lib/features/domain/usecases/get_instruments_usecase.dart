import 'package:dartz/dartz.dart';
import 'package:raise_right_task/core/errors/failure.dart';
import 'package:raise_right_task/core/utils/di/di.dart' show sl;
import 'package:raise_right_task/features/domain/entities/instruments.dart';
import 'package:raise_right_task/features/domain/repositories/IRepository.dart';
import 'package:raise_right_task/features/domain/repositories/InstrumentsRepository.dart';

class GetInstrumentsUseCase {
  final IRepository instrumentsRepository = sl<InstrumentsRepository>();
  Future<Either<Failure, List<Instrument>>> fetchInstruments() async {
    final eitherResult = await instrumentsRepository.fetchInitialInstruments();

    return eitherResult.map((models) {
      return models.map((model) {
        final tickSize = double.tryParse(model.tickSz) ?? 0.0;
        final lotSize = double.tryParse(model.lotSz) ?? 0.0;

        return Instrument(
          id: model.instId,
          baseCurrency: model.baseCcy,
          quoteCurrency: model.quoteCcy,
          tickSize: tickSize,
          lotSize: lotSize,
          isHighPrecision: tickSize < 0.0001,
        );
      }).toList();
    });
  }
}
