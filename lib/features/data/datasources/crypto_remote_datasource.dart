import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:raise_right_task/core/api_handler.dart';
import 'package:raise_right_task/core/constants/strings/app_constants.dart';
import 'package:raise_right_task/core/errors/failure.dart';
import 'package:raise_right_task/features/data/models/instruments_model.dart';
import 'package:raise_right_task/features/data/models/prices_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

abstract interface class CryptoRemoteDataSource {
  Future<Either<Failure, List<InstrumentModel>>> fetchInitialInstruments();
  Stream<PricesModel> subscribeToWebSocketEvents(List<String> symbols);
  void disposeWebSocket();
}

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  late Dio _dio;
  WebSocketChannel? _channel;

  CryptoRemoteDataSourceImpl() {
    _dio = Dio(BaseOptions(baseUrl: AppConstants.BASE_URL));
  }

  @override
  Future<Either<Failure, List<InstrumentModel>>> fetchInitialInstruments() {
    return ApiHandler.apiCaller<List<InstrumentModel>>(() async {
      final response = await _dio.get(
        AppConstants.API_ENDPOINT,
        queryParameters: {'instType': 'SPOT'},
      );

      if (response.statusCode == 200) {
        establishWebSocketConnection();
      }

      List<dynamic> instrumentsList = response.data["data"];
      return instrumentsList
          .map((e) => InstrumentModel.fromJson(e))
          .toList();
    });
  }

  void establishWebSocketConnection() {
    _channel = WebSocketChannel.connect(Uri.parse(AppConstants.WS_BASE_URL));
  }

  @override
  Stream<PricesModel> subscribeToWebSocketEvents(List<String> symbols) async* {
    if (_channel == null) {
      establishWebSocketConnection();
    }

    final subPayload = {
      "op": "subscribe",
      "args": symbols.map((symbol) {
        return {
          "channel": "tickers",
          "instId": symbol,
        };
      }).toList(),
    };

    _channel!.sink.add(jsonEncode(subPayload));

    await for (final message in _channel!.stream) {
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map &&
            decoded['arg'] != null &&
            decoded['data'] != null &&
            decoded['arg']['channel'] == 'tickers') {
          final List<dynamic> data = decoded['data'];
          for (final item in data) {
            yield PricesModel.fromJson(item);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void disposeWebSocket() {
    _channel?.sink.close(status.goingAway);
    _channel = null;
  }
}
