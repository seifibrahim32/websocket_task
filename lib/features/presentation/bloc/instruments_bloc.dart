import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raise_right_task/core/utils/di/di.dart';
import 'package:raise_right_task/features/data/models/prices_model.dart';
import 'package:raise_right_task/features/domain/entities/instruments.dart';
import 'package:raise_right_task/features/domain/usecases/get_instruments_usecase.dart';
import 'package:raise_right_task/features/domain/usecases/subscribe_instruments_updates.dart';
import 'package:raise_right_task/features/presentation/bloc/events/events.dart';
import 'package:raise_right_task/features/presentation/bloc/states/states.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InstrumentsBloc extends Bloc<InstrumentsEvent, InstrumentsState> {
  late final GetInstrumentsUseCase _getInstruments;
  late final SubscribeInstrumentsUseCase _instrumentsSubscriber;

  StreamSubscription<PricesModel>? _wsSubscription;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  final List<Instrument> _cachedInstruments = [];
  ConnectivityResult _lastConnectionStatus = ConnectivityResult.none;

  InstrumentsBloc() : super(InstrumentsInitial()) {
    _getInstruments = sl<GetInstrumentsUseCase>();
    _instrumentsSubscriber = sl<SubscribeInstrumentsUseCase>();

    on<LoadInstruments>(_onLoadInstruments);
    on<InstrumentUpdated>(_onInstrumentUpdated);
    on<InstrumentFailed>(_onFailed);

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
          if (result != _lastConnectionStatus) {
            _lastConnectionStatus = result;

            if (result == ConnectivityResult.none) {
              _cachedInstruments.clear();
              add(InstrumentFailed());
            } else {
              add(LoadInstruments());
            }
          }
        });
  }

  Future<void> _onLoadInstruments(
      LoadInstruments event,
      Emitter<InstrumentsState> emit,
      ) async {
    emit(InstrumentsLoading());

    final result = await _getInstruments.fetchInstruments();

    await result.fold(
          (failure) async {
        emit(InstrumentsError(failure.message));
        await _wsSubscription?.cancel();
        _instrumentsSubscriber.dispose();
      },
          (instrumentsList) async {
        _cachedInstruments
          ..clear()
          ..addAll(instrumentsList);

        emit(InstrumentsLoaded(List.from(_cachedInstruments)));

        await _wsSubscription?.cancel();

        _wsSubscription = _instrumentsSubscriber
            .subscribeToPriceUpdates()
            .listen((pricesModel) {
          add(InstrumentUpdated(pricesModel));
        });
      },
    );
  }

  Future<void> _onInstrumentUpdated(
      InstrumentUpdated event,
      Emitter<InstrumentsState> emit,
      ) async {
    if (state is! InstrumentsLoaded) return;

    bool updated = false;

    for (int i = 0; i < _cachedInstruments.length; i++) {
      if (_cachedInstruments[i].id == event.updatedInstrument.instId) {
        _cachedInstruments[i] = _cachedInstruments[i].copyWithPrices(
          event.updatedInstrument,
        );
        updated = true;
        break;
      }
    }

    if (updated) {
      emit(InstrumentsLoaded(List.from(_cachedInstruments)));
    }
  }

  void _onFailed(
      InstrumentFailed event,
      Emitter<InstrumentsState> emit){
    emit(InstrumentsError('No internet connection'));
  }

  @override
  Future<void> close() async {
    await _wsSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    _instrumentsSubscriber.dispose();
    return super.close();
  }
}