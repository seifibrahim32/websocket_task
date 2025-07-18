import 'package:equatable/equatable.dart';
import 'package:raise_right_task/features/data/models/prices_model.dart';

abstract class InstrumentsEvent extends Equatable {
  const InstrumentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadInstruments extends InstrumentsEvent {}

class InstrumentUpdated extends InstrumentsEvent {
  final PricesModel updatedInstrument;

  const InstrumentUpdated(this.updatedInstrument);

  @override
  List<Object?> get props => [updatedInstrument];
}
class InstrumentFailed extends InstrumentsEvent {

  const InstrumentFailed();

  @override
  List<Object?> get props => [];
}
