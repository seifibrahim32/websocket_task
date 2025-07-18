class PricesModel {
  final String instType;
  final String instId;
  final String last;
  final String lastSz;
  final String askPx;
  final String askSz;
  final String bidPx;
  final String bidSz;
  final String open24h;
  final String high24h;
  final String low24h;
  final String sodUtc0;
  final String sodUtc8;
  final String volCcy24h;
  final String vol24h;
  final String ts;

  PricesModel({
    required this.instType,
    required this.instId,
    required this.last,
    required this.lastSz,
    required this.askPx,
    required this.askSz,
    required this.bidPx,
    required this.bidSz,
    required this.open24h,
    required this.high24h,
    required this.low24h,
    required this.sodUtc0,
    required this.sodUtc8,
    required this.volCcy24h,
    required this.vol24h,
    required this.ts,
  });

  factory PricesModel.fromJson(Map<String, dynamic> json) {
    return PricesModel(
      instType: json['instType'],
      instId: json['instId'],
      last: json['last'],
      lastSz: json['lastSz'],
      askPx: json['askPx'],
      askSz: json['askSz'],
      bidPx: json['bidPx'],
      bidSz: json['bidSz'],
      open24h: json['open24h'],
      high24h: json['high24h'],
      low24h: json['low24h'],
      sodUtc0: json['sodUtc0'],
      sodUtc8: json['sodUtc8'],
      volCcy24h: json['volCcy24h'],
      vol24h: json['vol24h'],
      ts: json['ts'],
    );
  }
}
