import 'package:dartz/dartz.dart';
import 'package:raise_right_task/core/errors/failure.dart';
import 'package:raise_right_task/features/data/models/instruments_model.dart';
import 'package:raise_right_task/features/data/models/prices_model.dart';

abstract interface class IRepository {
  Future<Either<Failure, List<InstrumentModel>>> fetchInitialInstruments();
  Stream<PricesModel> subscribeToPriceUpdates();
  void dispose();
}
