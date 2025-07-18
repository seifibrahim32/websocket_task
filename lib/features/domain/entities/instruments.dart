import 'package:raise_right_task/features/data/models/prices_model.dart';

class Instrument {
  final String id;
  final String baseCurrency;
  final String quoteCurrency;
  final double tickSize;
  final double lotSize;
  final bool isHighPrecision;

  final double? askPx;
  final double? bidPx;
  final double? lastPx;

  final double? vol24h;

  Instrument({
    required this.id,
    required this.baseCurrency,
    required this.quoteCurrency,
    required this.tickSize,
    required this.lotSize,
    required this.isHighPrecision,
    this.askPx,
    this.bidPx,
    this.lastPx,
    this.vol24h
  });

  Instrument copyWithPrices(PricesModel model) {
    return Instrument(
      id: id,
      baseCurrency: baseCurrency,
      quoteCurrency: quoteCurrency,
      tickSize: tickSize,
      lotSize: lotSize,
      isHighPrecision: isHighPrecision,
      askPx: double.tryParse(model.askPx),
      bidPx: double.tryParse(model.bidPx),
      lastPx: double.tryParse(model.last),
      vol24h: double.tryParse(model.vol24h)
    );
  }
}
