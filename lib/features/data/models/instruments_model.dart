class InstrumentModel {
  final String instId;      // e.g., USDT-SGD
  final String baseCcy;     // e.g., USDT
  final String quoteCcy;    // e.g., SGD
  final String instType;    // e.g., SPOT
  final String state;       // e.g., live
  final String tickSz;      // e.g., 0.0001
  final String lotSz;       // e.g., 0.001
  final DateTime? listTime; // parsed from epoch

  InstrumentModel({
    required this.instId,
    required this.baseCcy,
    required this.quoteCcy,
    required this.instType,
    required this.state,
    required this.tickSz,
    required this.lotSz,
    this.listTime,
  });

  factory InstrumentModel.fromJson(Map<String, dynamic> json) {
    return InstrumentModel(
      instId: json['instId'] ?? '',
      baseCcy: json['baseCcy'] ?? '',
      quoteCcy: json['quoteCcy'] ?? '',
      instType: json['instType'] ?? '',
      state: json['state'] ?? '',
      tickSz: json['tickSz'] ?? '',
      lotSz: json['lotSz'] ?? '',
      listTime: json['listTime'] != null && json['listTime'] != ''
          ? DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['listTime']) ?? 0)
          : null,
    );
  }
}
