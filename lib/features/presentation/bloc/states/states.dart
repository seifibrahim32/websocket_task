import 'package:equatable/equatable.dart';
import 'package:raise_right_task/features/domain/entities/instruments.dart';

abstract class InstrumentsState extends Equatable {
  const InstrumentsState();

  @override
  List<Object?> get props => [];
}

class InstrumentsInitial extends InstrumentsState {}

class InstrumentsLoading extends InstrumentsState {}

class InstrumentsLoaded extends InstrumentsState {
  final List<Instrument> instruments;
  final bool isConnected;

  const InstrumentsLoaded(this.instruments, {this.isConnected = true});

  @override
  List<Object?> get props => [instruments, isConnected];
}

class InstrumentsError extends InstrumentsState {
  final String message;

  const InstrumentsError(this.message);

  @override
  List<Object?> get props => [message];
}
